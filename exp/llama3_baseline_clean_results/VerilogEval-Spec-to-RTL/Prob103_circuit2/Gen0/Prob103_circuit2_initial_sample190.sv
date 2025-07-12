module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;
    
    assign q = (a && !b && !c && !d) ? 0 :
               (a && !b && c && !d) ? 1 :
               (a && !b && !c && d) ? 1 :
               (a && !b && c && d) ? 0 :
               (a && b && !c && !d) ? 1 :
               (a && b && c && !d) ? 0 :
               (a && b && !c && d) ? 0 :
               (a && b && c && d) ? 1 :
               (!a && b && !c && !d) ? 0 :
               (!a && b && c && !d) ? 1 :
               (!a && b && !c && d) ? 1 :
               (!a && b && c && d) ? 0 :
               (!a && !b && c && !d) ? 0 :
               (!a && !b && !c && d) ? 0 :
               (!a && !b && c && d) ? 1 :
               (!a && !b && !c && !d) ? 1 : 1;
endmodule