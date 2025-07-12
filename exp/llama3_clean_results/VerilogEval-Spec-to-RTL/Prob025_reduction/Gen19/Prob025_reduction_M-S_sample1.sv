module TopModule(
    input wire [7:0] in,  
    output wire parity    
);
    
assign parity = ^in;

endmodule