module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding:
    // [1] - 1=falling, 0=walking
    // [0] - walking direction (0=left, 1=right), maintained during fall
    reg [1:0] state, next_state;
    
    // State transition logic
    always @(*) begin
        if (state[1]) begin // Currently falling
            next_state = ground ? {1'b0, state[0]} : state;
        end else begin // Currently walking
            if (!ground) begin
                next_state = {1'b1, state[0]}; // Start falling, remember direction
            end else begin
                // Switch direction only when bumped on current side
                case (state[0])
                    1'b0: next_state = bump_left ? 2'b01 : 2'b00; // left->right if bumped
                    1'b1: next_state = bump_right ? 2'b00 : 2'b01; // right->left if bumped
                endcase
            end
        end
    end
    
    // State register with async reset and transition optimization
    always @(posedge clk, posedge areset) begin
        if (areset) state <= 2'b00; // Start walking left
        else if (state != next_state) state <= next_state;
    end
    
    // Optimized output logic
    assign walk_left = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & state[0];
    assign aaah = state[1];

endmodule