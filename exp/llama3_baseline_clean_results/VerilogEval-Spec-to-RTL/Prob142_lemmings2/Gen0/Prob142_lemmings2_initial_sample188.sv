module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] prev_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initialize to walking_left state
        prev_state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // walking_left state
                if (bump_left) begin
                    state <= 2'b01; // Transition to walking_right state
                end else if (~ground) begin
                    prev_state <= 2'b00;
                    state <= 2'b10; // Transition to falling state
                end
            end
            2'b01: begin // walking_right state
                if (bump_right) begin
                    state <= 2'b00; // Transition to walking_left state
                end else if (~ground) begin
                    prev_state <= 2'b01;
                    state <= 2'b10; // Transition to falling state
                end
            end
            2'b10: begin // falling state
                if (ground) begin
                    state <= prev_state; // Transition back to previous state
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

always_comb begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule