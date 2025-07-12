module TopModule(
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // High byte register (bits 15:8)
    reg [7:0] hi_byte;
    // Low byte register (bits 7:0)
    reg [7:0] lo_byte;

    always @(*) begin
        hi_byte = in[15:8];
        lo_byte = in[7:0];
    end

    assign out_hi = hi_byte;
    assign out_lo = lo_byte;

endmodule