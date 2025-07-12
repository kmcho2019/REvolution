module TopModule(
    input  [7:0] in,  
    output parity    
);

// Use the XOR reduction operator (^) to compute the parity bit
assign parity = ^in;

endmodule