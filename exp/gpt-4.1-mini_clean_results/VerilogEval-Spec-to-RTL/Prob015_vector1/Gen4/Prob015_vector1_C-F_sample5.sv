module TopModule (
    input  [15:0] in,       // 16-bit input word
    output reg [7:0] out_hi, // upper byte of input [15:8]
    output reg [7:0] out_lo  // lower byte of input [7:0]
);

    // Combinational logic: split 16-bit input into two 8-bit outputs
    always @(*) begin
        out_hi = in[15:8];
        out_lo = in[7:0];
    end

endmodule