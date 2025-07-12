module Rule110NextState(
    input left,
    input center,
    input right,
    output next_state
);

always_comb begin
    case ({left, center, right})
        3'b111: next_state = 0;
        3'b110: next_state = 1;
        3'b101: next_state = 1;
        3'b100: next_state = 0;
        3'b011: next_state = 1;
        3'b010: next_state = 1;
        3'b001: next_state = 1;
        3'b000: next_state = 0;
        default: next_state = 0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Use a generate statement to instantiate the next state calculation for each cell
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        wire next_state;

        if (i == 0) assign left = 0; else assign left = q_reg[i - 1];
        assign center = q_reg[i];
        if (i == 511) assign right = 0; else assign right = q_reg[i + 1];

        Rule110NextState next_state_calc(
            .left(left),
            .center(center),
            .right(right),
            .next_state(next_state)
        );

        // Sequential logic to update q_reg
        always @(posedge clk) begin
            if (load) begin
                q_reg[i] <= data[i];
            end else begin
                q_reg[i] <= next_state;
            end
        end
    end
endgenerate

assign q = q_reg;

endmodule