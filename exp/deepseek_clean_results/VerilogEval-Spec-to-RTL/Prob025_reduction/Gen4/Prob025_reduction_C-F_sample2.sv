module TopModule (
    input [7:0] in,      // 8-bit input data
    output parity        // Even parity bit output
);
    always @(*) begin
        parity = ^in;    // XOR reduction for even parity
    end
endmodule