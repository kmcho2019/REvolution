module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

// Decoder output
wire decoder_out;
assign decoder_out = sel_b1 && sel_b2;

// Continuous assignment
assign out_assign = decoder_out ? b : a;

// Procedural assignment
always @(*) begin
    if (decoder_out) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule