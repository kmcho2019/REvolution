module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter STATE_LEFT = 1'b0;
parameter STATE_RIGHT = 1'b1;

// Internal signals
reg current_state;
reg next_state;

// Output logic
assign walk_left = (current_state == STATE_LEFT)? 1'b1 : 1'b0;
assign walk_right = (current_state == STATE_RIGHT)? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(current_state)
        STATE_LEFT: begin
            if(bump_left) begin
                next_state = STATE_RIGHT;
            end else begin
                next_state = current_state;
            end
        end
        STATE_RIGHT: begin
            if(bump_right) begin
                next_state = STATE_LEFT;
            end else begin
                next_state = current_state;
            end
        end
        default: begin
            next_state = STATE_LEFT;
        end
    endcase

    if(bump_left && bump_right) begin
        next_state = ~current_state;
    end
end

// State register
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= STATE_LEFT;
    end else begin
        current_state <= next_state;
    end
end

endmodule