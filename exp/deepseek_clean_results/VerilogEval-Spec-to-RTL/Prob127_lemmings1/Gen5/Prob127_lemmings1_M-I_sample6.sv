module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding (1-bit for minimal area)
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;
    reg state_d;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (state)
                LEFT:  state <= bump_left ? RIGHT : LEFT;
                RIGHT: state <= bump_right ? LEFT : RIGHT;
            endcase
        end
    end

    // State change detection for output gating
    always @(posedge clk) begin
        state_d <= state;
    end

    // Registered outputs with gating (only update when state changes)
    always @(posedge clk) begin
        if (state != state_d) begin
            walk_left <= ~state;
            walk_right <= state;
        end
    end

endmodule