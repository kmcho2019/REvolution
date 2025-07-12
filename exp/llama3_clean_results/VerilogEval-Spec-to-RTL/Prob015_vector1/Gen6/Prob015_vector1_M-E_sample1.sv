module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    reg [7:0] upper_bits;
    reg [7:0] lower_bits;

    always @(in) begin
        upper_bits = in[15:8];
        lower_bits = in[7:0];
    end

    assign out_hi = upper_bits;
    assign out_lo = lower_bits;

endmodule