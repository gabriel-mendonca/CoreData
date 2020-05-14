//
//  ListarNotasTableViewController.swift
//  CoreDataProject
//
//  Created by Gabriel Mendonça on 14/05/20.
//  Copyright © 2020 Gabriel Mendonça. All rights reserved.
//

import UIKit
import CoreData

class ListarNotasTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnotacao()
    }
    
    func recuperarAnotacao() {
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        let cordenacao = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [cordenacao]
        
        do {
            let anotacoesRecuperadas = try context.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let erro as NSError {
            print("Erro ao recuperar dados: \(erro), \(erro.localizedDescription)")
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anotacoes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let anotar = anotacoes[indexPath.row]
        let recuperarNotas = anotar.value(forKey: "texto")
        let recuperarData = anotar.value(forKey: "data")
        
        // formatar data
        let formatarData = DateFormatter()
        formatarData.dateFormat = "dd/MM/yyyy hh:mm"
        let novaData = formatarData.string(from: recuperarData as! Date)
        
        cell.textLabel?.text = recuperarNotas as? String
        cell.detailTextLabel?.text = novaData
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indice  = indexPath.row
        let anotacao = self.anotacoes[indice]
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao" {
            
            let viewDestino = segue.destination as! AnotacoesViewController
            
            viewDestino.anotacao = sender as? NSManagedObject
            
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            
            self.context.delete(anotacao)
            self.anotacoes.remove(at: indice)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try context.save()
            } catch let erro as NSError {
                print("Erro ao remover item: \(erro.localizedDescription)")
            }
        }
    }
}
