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

// Enumerate states
enum logic [1:0] {WL, WR, FL, FR} state, next_state;

// Initial state (on reset)
always @(posedge areset or negedge clk) begin
    if (areset) begin
        state <= WL;
    end else if (clk) begin
        state <= next_state;
    end
end

// Determine next state
always @(*) begin
    case (state)
        WL: begin
            if (ground == 0) begin
                next_state = FL;
            end else if (bump_left == 1) begin
                next_state = WR;
            end else if (bump_right == 1) begin
                next_state = WL;
            end else begin
                next_state = WL;
            end
        end
        WR: begin
            if (ground == 0) begin
                next_state = FR;
            end else if (bump_right == 1) begin
                next_state = WL;
            end else if (bump_left == 1) begin
                next_state = WR;
            end else begin
                next_state = WR;
            end
        end
        FL: begin
            if (ground == 1) begin
                next_state = WL;
            end else begin
                next_state = FL;
            end
        end
        FR: begin
            if (ground == 1) begin
                next_state = WR;
            end else begin
                next_state = FR;
            end
        end
    endcase
end

// Determine outputs
always @(*) begin
    case (state)
        WL: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        WR: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        FR: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule