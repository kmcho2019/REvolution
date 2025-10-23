module TopModule (
    input [7:0] in,       // 8-bit input data
    output reg parity     // Even parity bit (XOR of all input bits)
);
    // Compute even parity using procedural assignment
    always @(*) begin
        parity = ^in;     // XOR reduction of all input bits
    end
endmodule