module Cell(
    input left,
    input center,
    input right,
    output reg q
);

always @(*) begin
    case ({left, center, right})
        3'b111, 3'b000, 3'b001, 3'b010: q = 1'b0;
        default: q = 1'b1;
    endcase
end

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        state <= next_state;
    end
end

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        if (i == 0) begin
            assign left = 1'b0;
        end else begin
            assign left = state[i - 1];
        end
        assign center = state[i];
        if (i == 511) begin
            assign right = 1'b0;
        end else begin
            assign right = state[i + 1];
        end
        Cell cell_i (
           .left(left),
           .center(center),
           .right(right),
           .q(next_state[i])
        );
    end
endgenerate

assign q = state;

endmodule