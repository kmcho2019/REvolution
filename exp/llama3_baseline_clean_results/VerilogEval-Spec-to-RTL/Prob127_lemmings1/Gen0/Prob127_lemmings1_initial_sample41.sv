module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
parameter STATE_LEFT = 0;
parameter STATE_RIGHT = 1;

// Declare the current and next state
reg [0:0] current_state;
reg [0:0] next_state;

// Assign the outputs based on the current state
assign walk_left = (current_state == STATE_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == STATE_RIGHT) ? 1'b1 : 1'b0;

// State machine logic
always @(*) begin
    case (current_state)
        STATE_LEFT: begin
            if (bump_left) begin
                next_state = STATE_RIGHT;
            end else if (bump_right) begin
                next_state = STATE_LEFT; // Stay in the same state if only bumped on the right
            end else begin
                next_state = STATE_LEFT;
            end
        end
        STATE_RIGHT: begin
            if (bump_right) begin
                next_state = STATE_LEFT;
            end else if (bump_left) begin
                next_state = STATE_RIGHT; // Stay in the same state if only bumped on the left
            end else begin
                next_state = STATE_RIGHT;
            end
        end
        default: begin
            next_state = STATE_LEFT;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            current_state <= (current_state == STATE_LEFT) ? STATE_RIGHT : STATE_LEFT;
        end else begin
            current_state <= next_state;
        end
    end
end

endmodule