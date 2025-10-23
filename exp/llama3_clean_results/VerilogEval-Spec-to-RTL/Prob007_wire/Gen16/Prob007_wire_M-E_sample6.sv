module TopModule(
    input  in,
    output out
);
    
    // Define a 2-to-1 multiplexer
    wire sel;  // Select signal
    assign sel = 1'b0;  // Constant select signal
    
    // MUX implementation
    assign out = (sel)? 1'b0 : in;

endmodule