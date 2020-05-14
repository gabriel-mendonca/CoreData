//
//  AnotacoesViewController.swift
//  CoreDataProject
//
//  Created by Gabriel Mendonça on 14/05/20.
//  Copyright © 2020 Gabriel Mendonça. All rights reserved.
//

import UIKit
import CoreData

class AnotacoesViewController: UIViewController {
    
    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.texto.becomeFirstResponder()
        
        if anotacao != nil {
            let recuperado = anotacao.value(forKey: "texto")
            self.texto.text = recuperado as? String
            
        } else {
            self.texto.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    @IBAction func salvar(_ sender: UIBarButtonItem) {
        if  anotacao != nil{
            self.atualizarDados()
            
            let alert = UIAlertController(title: "Aviso", message: "Anotação atualizado com sucesso!", preferredStyle: .alert)
            let acao = UIAlertAction(title: "OK", style: .default) { (acao) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(acao)
            present(alert, animated: true, completion: nil)
        } else {
            self.salvarAnotacao()
            let alert = UIAlertController(title: "Aviso", message: "Anotação salvo com sucesso!", preferredStyle: .alert)
            let acao = UIAlertAction(title: "OK", style: .default) { (acao) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(acao)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func atualizarDados() {
        
        anotacao.setValue(self.texto.text, forKey: "texto")
        anotacao.setValue(Date(), forKey: "data")
        
        do {
            try context.save()
            let alert = UIAlertController(title: "Aviso", message: "Dados atualizados com sucesso!", preferredStyle: .alert)
            let acao = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(acao)
        } catch let erro as NSError {
            print("Erro ao atualizar dados: \(erro.localizedDescription)")
        }
        
        
    }
    
    func salvarAnotacao() {
        let salvarAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
        salvarAnotacao.setValue(self.texto.text, forKey: "texto")
        salvarAnotacao.setValue(Date(), forKey: "data")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("erro o texto nao foi salvo \(error), \(error.userInfo)")
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
