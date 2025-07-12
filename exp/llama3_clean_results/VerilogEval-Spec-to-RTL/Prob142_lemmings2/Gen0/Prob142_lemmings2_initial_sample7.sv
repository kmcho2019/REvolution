module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] current_state;
reg [1:0] next_state;

// Moore state machine: 
// WL: 2'b00
// WR: 2'b01
// F: 2'b10

always @(*) begin
    case(current_state)
        2'b00: begin // Walking Left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1) begin
                next_state = 2'b01; // Walking Right
            end else if (bump_right == 1'b0) begin
                next_state = 2'b00; // Still Walking Left
            end else begin // bump_right == 1'b1
                next_state = 2'b00; // Still Walking Left, since we don't switch when both bump_left and bump_right are high at the same time, the comment was wrong. Switching should occur regardless.
                next_state = 2'b01; 
            end
        end
        2'b01: begin // Walking Right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_right == 1'b1) begin
                next_state = 2'b00; // Walking Left
            end else if (bump_left == 1'b0) begin
                next_state = 2'b01; // Still Walking Right
            end else begin // bump_left == 1'b1
                next_state = 2'b00; // Walking Left, since we don't switch when both bump_left and bump_right are high at the same time, the comment was wrong. Switching should occur regardless.
            end
        end
        2'b10: begin // Falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (current_state == 2'b10) begin
                    if (bump_left == 1'b1 || bump_right == 1'b1) begin
                        if (bump_right == 1'b1) next_state = 2'b00;
                        else next_state = 2'b01;
                    end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
                        if (bump_left == 1'b1) next_state = 2'b01;
                        else next_state = 2'b00;
                    end else next_state = current_state;
                end else next_state = current_state;
            end else next_state = current_state;
        end
        default: begin // invalid state, should not happen
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            next_state = 2'b00; // default to Walking Left
        end
    endcase

    if (areset == 1'b1) begin
        next_state = 2'b00; // reset to Walking Left
    end
end

always @(posedge clk) begin
    current_state <= next_state;
end

initial begin
    current_state = 2'b00;
end

endmodule