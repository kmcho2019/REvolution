module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] outer_state; // Outer state machine: 2'b00 - walking, 2'b01 - falling
reg inner_state; // Inner state machine: 1'b0 - walking left, 1'b1 - walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        outer_state <= 2'b00; // Reset to walking state
        inner_state <= 1'b0; // Reset to walking left
    end else begin
        case(outer_state)
            2'b00: // Walking state
                begin
                    if (~ground) begin
                        outer_state <= 2'b01; // Transition to falling state
                    end else begin
                        // Inner state machine logic for walking state
                        if (bump_left) begin
                            inner_state <= 1'b1; // Switch to walking right
                        end else if (bump_right) begin
                            inner_state <= 1'b0; // Switch to walking left
                        end
                    end
                end
            2'b01: // Falling state
                begin
                    if (ground) begin
                        outer_state <= 2'b00; // Transition back to walking state
                    end
                end
        endcase
    end
end

// Output logic based on outer and inner states
always @(*) begin
    walk_left = (outer_state == 2'b00 && inner_state == 1'b0) ? 1'b1 : 1'b0;
    walk_right = (outer_state == 2'b00 && inner_state == 1'b1) ? 1'b1 : 1'b0;
    aaah = (outer_state == 2'b01) ? 1'b1 : 1'b0;
end

endmodule