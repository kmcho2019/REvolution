module TopModule (input a, b, c, d, output q);
    wire first_int, second_int;
    
    assign first_int = b | c;
    assign second_int = a & d;
    assign q = first_int & ~second_int;
endmodule