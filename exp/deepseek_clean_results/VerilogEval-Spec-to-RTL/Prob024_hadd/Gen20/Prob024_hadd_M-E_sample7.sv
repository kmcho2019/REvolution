module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum output implemented with mux
    assign sum = a ? ~b : b;
    
    // Carry output remains simple AND
    assign cout = a & b;
endmodule