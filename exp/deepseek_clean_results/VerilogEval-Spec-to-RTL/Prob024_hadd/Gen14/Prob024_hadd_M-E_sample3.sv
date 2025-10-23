module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum output implemented with mux: sum = b ? ~a : a
    assign sum = b ? ~a : a;
    
    // Carry output implemented with mux: cout = b ? a : 0
    assign cout = b ? a : 1'b0;
endmodule