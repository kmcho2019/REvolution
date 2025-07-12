module TopModule (
    input [7:0] in,       // 8-bit input data
    output reg parity     // Even parity bit (XOR of all input bits)
);
    // Compute even parity by XORing all input bits
    // This gives 0 for even number of 1s, 1 for odd number of 1s
    always @(*) begin
        parity = ^in;
    end
endmodule