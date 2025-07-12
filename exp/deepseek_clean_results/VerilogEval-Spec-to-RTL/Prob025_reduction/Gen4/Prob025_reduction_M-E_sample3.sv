module TopModule (
    input [7:0] in,
    output parity
);
    wire parity_lower = ^in[3:0];  // XOR of lower nibble
    wire parity_upper = ^in[7:4];  // XOR of upper nibble
    
    assign parity = parity_lower ^ parity_upper;  // Final XOR
endmodule