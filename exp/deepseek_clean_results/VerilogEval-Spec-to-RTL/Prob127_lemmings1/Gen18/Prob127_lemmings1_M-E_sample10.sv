module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    reg next_state;
    reg [1:0] output_reg;

    // Combinational next state and output logic
    always @(*) begin
        case (state)
            1'b0: next_state = bump_left ? 1'b1 : 1'b0;  // if left, turn right on bump_left
            1'b1: next_state = bump_right ? 1'b0 : 1'b1;  // if right, turn left on bump_right
        endcase

        // Pre-compute outputs
        output_reg[0] = ~next_state;  // walk_left
        output_reg[1] = next_state;   // walk_right
    end

    // Dual-edge triggered state register with async reset
    always @(posedge clk or negedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // reset to left
        end else begin
            state <= next_state;
        end
    end

    assign walk_left = output_reg[0];
    assign walk_right = output_reg[1];

endmodule