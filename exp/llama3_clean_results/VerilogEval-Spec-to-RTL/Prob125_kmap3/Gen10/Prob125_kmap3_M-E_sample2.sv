module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire intermediate_out;
    
    // Logic when 'a' is 0
    assign intermediate_out = ~b && c;
    
    // Using 'a' as the select line of the multiplexer
    assign out = a ? 1'b1 : intermediate_out;

endmodule