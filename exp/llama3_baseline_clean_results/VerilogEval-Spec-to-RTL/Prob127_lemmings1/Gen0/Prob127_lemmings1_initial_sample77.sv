module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter STATE_LEFT = 0;
parameter STATE_RIGHT = 1;

// Declare reg to store current state
reg [0:0] current_state;

// Initialize current state to STATE_LEFT
initial begin
    current_state = STATE_LEFT;
end

// Combinational logic to determine next state
always @(*) begin
    case (current_state)
        STATE_LEFT: begin
            if (bump_left) begin
                current_state = STATE_RIGHT;
            end else begin
                current_state = STATE_LEFT;
            end
        end
        STATE_RIGHT: begin
            if (bump_right) begin
                current_state = STATE_LEFT;
            end else begin
                current_state = STATE_RIGHT;
            end
        end
        default: begin
            current_state = STATE_LEFT;
        end
    endcase
end

// Sequential logic to update current state and output values
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_LEFT;
    end else begin
        if (bump_left) begin
            current_state <= STATE_RIGHT;
        end else if (bump_right) begin
            current_state <= STATE_LEFT;
        end else begin
            // current_state remains the same if no bump signals
            current_state <= current_state;
        end
    end
end

// Output logic
assign walk_left = (current_state == STATE_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == STATE_RIGHT) ? 1'b1 : 1'b0;

endmodule