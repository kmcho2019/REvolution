module TopModule (
    input  [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);

    reg [7:0] hi_reg;
    reg [7:0] lo_reg;

    always @(*) begin
        hi_reg = (in >> 8) & 8'hFF;
        lo_reg = in & 8'hFF;
    end

    assign out_hi = hi_reg;
    assign out_lo = lo_reg;

endmodule