module TopModule(
    input  [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

// Calculate the parity bit using a concise and efficient approach
always @(*) begin
    parity = ^in;  // Using the reduction XOR operator (^) on the input vector
end

endmodule