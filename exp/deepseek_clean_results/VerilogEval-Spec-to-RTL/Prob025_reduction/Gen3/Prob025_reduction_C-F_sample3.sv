module TopModule (
    input [7:0] in,       // 8-bit input data
    output reg parity     // Even parity bit output
);
    always @(*) begin
        parity = ^in;     // Optimal XOR reduction for even parity
    end
endmodule