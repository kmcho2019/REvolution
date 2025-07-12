module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // 2-bit state register
reg [1:0] next_state; // next state

// Output logic
assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);
assign digging = (state == 2'b11);

// State transition logic
always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (!ground) begin
                next_state = 2'b10; // fall
            end else if (dig) begin
                next_state = 2'b11; // dig
            end else if (bump_left) begin
                next_state = 2'b01; // switch to walking right
            end else if (bump_right) begin
                next_state = 2'b01; // switch to walking right
            end else begin
                next_state = 2'b00; // stay in walking left
            end
        end
        2'b01: begin // walking right
            if (!ground) begin
                next_state = 2'b10; // fall
            end else if (dig) begin
                next_state = 2'b11; // dig
            end else if (bump_right) begin
                next_state = 2'b00; // switch to walking left
            end else if (bump_left) begin
                next_state = 2'b00; // switch to walking left
            end else begin
                next_state = 2'b01; // stay in walking right
            end
        end
        2'b10: begin // falling
            if (ground) begin
                if (state == 2'b10 && dig) begin
                    next_state = 2'b11; // dig
                end else begin
                    next_state = (bump_left)? 2'b01 : (bump_right)? 2'b00 : (state == 2'b10 &&!dig)? ((bump_left || bump_right)? (bump_left)? 2'b01 : 2'b00 : 2'b00) : 2'b00;
                end
            end else begin
                next_state = 2'b10; // stay in falling
            end
        end
        2'b11: begin // digging
            if (!ground) begin
                next_state = 2'b10; // fall
            end else begin
                next_state = 2'b11; // stay in digging
            end
        end
        default: next_state = 2'b00;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

endmodule