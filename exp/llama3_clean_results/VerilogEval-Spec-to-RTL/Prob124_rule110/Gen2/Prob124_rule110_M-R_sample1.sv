module Rule110Cell(
    input left,
    input center,
    input right,
    output next_state
);

assign next_state = (left & center & right) ? 0 :
                    (left & center & ~right) ? 1 :
                    (left & ~center & right) ? 1 :
                    (left & ~center & ~right) ? 0 :
                    (~left & center & right) ? 1 :
                    (~left & center & ~right) ? 1 :
                    (~left & ~center & right) ? 1 :
                    (~left & ~center & ~right) ? 0 : 0;

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

Rule110Cell cell_0(
    .left(0),
    .center(current_state[0]),
    .right(current_state[1]),
    .next_state(next_state[0])
);

Rule110Cell cell_511(
    .left(current_state[510]),
    .center(current_state[511]),
    .right(0),
    .next_state(next_state[511])
);

generate
    for (genvar i = 1; i < 511; i++) begin
        Rule110Cell cell_inst(
            .left(current_state[i-1]),
            .center(current_state[i]),
            .right(current_state[i+1]),
            .next_state(next_state[i])
        );
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule