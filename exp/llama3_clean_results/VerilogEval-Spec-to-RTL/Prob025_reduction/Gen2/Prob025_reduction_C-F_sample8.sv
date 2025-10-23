module TopModule(
    input [7:0] in,  // 8-bit input
    output reg parity   // 1-bit parity output
);

always @(*) begin
    // Calculate the parity bit by XORing all input bits directly
    parity = ^in;  // The ^ operator performs XOR on all bits of the vector
end

endmodule