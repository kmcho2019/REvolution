module TopModule(
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    always @(*) begin
        out_hi = in[15:8];
        out_lo = in[7:0];
    end

endmodule