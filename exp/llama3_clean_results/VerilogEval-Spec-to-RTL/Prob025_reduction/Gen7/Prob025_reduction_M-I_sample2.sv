module TopModule(
    input  [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

// Calculate the parity bit using an efficient XOR reduction
always @(*) begin
    parity = ^in;  // Using the vector XOR operator (^) for conciseness and efficiency
end

endmodule