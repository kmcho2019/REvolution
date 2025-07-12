module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

always @(*) begin
    out_lo = in[7:0];  // assign lower 8 bits of in to out_lo
    out_hi = in[15:8]; // assign upper 8 bits of in to out_hi
end

endmodule