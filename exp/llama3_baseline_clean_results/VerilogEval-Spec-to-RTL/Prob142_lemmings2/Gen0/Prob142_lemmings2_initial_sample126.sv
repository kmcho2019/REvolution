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

reg [1:0] state;
reg [1:0] prev_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left state
        prev_state <= 2'b00;
    end else begin
        case (state)
            2'b00: // walking left
                if (ground == 1'b0) begin
                    state <= 2'b10; // falling
                end else if (bump_left == 1'b1) begin
                    state <= 2'b01; // walking right
                end else if (bump_right == 1'b0) begin
                    state <= 2'b00; // stay in walking left state
                end else begin
                    state <= 2'b01; // walking right
                end
            2'b01: // walking right
                if (ground == 1'b0) begin
                    state <= 2'b10; // falling
                end else if (bump_left == 1'b0) begin
                    state <= 2'b00; // walking left
                end else if (bump_right == 1'b1) begin
                    state <= 2'b00; // walking left
                end else begin
                    state <= 2'b01; // stay in walking right state
                end
            2'b10: // falling
                if (ground == 1'b1) begin
                    state <= prev_state; // go back to previous walking state
                end else begin
                    state <= 2'b10; // stay in falling state
                end
            default:
                state <= 2'b00;
        endcase
        
        if (ground == 1'b0) begin
            prev_state <= state;
        end
    end
end

always @(*) begin
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