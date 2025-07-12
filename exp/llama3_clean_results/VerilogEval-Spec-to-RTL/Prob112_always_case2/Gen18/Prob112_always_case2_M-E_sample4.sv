module TwoBitPriorityEncoder(
    input  [1:0] in,
    output reg [0:0] pos,
    output reg no_one_found
);

always @(*) begin
    pos = 1'b0;
    no_one_found = 1'b1;
    if (in[1]) pos = 1'b1;
    else if (in[0]) begin
        pos = 1'b0;
        no_one_found = 1'b0;
    end else begin
        no_one_found = 1'b1;
    end
end

endmodule

module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

wire no_one_found_in_lower_bits;

TwoBitPriorityEncoder lower_bits(
    .in(in[1:0]),
    .pos(pos[0]),
    .no_one_found(no_one_found_in_lower_bits)
);

TwoBitPriorityEncoder upper_bits(
    .in(in[3:2]),
    .pos(pos[1]),
    .no_one_found()
);

always @(*) begin
    if (no_one_found_in_lower_bits)
        pos = {upper_bits.pos, 1'b0};
    else
        pos = {1'b0, lower_bits.pos};
end

endmodule