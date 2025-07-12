module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
typedef enum logic [0:0] {LEFT, RIGHT} state_t;

// Current and next state
state_t current_state;
state_t next_state;

// Sequential logic for state transitions
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for state transitions
always_comb begin
    case (current_state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        default: begin
            next_state = LEFT;
        end
    endcase
    
    if (bump_left && bump_right) begin
        case (current_state)
            LEFT: begin
                next_state = RIGHT;
            end
            RIGHT: begin
                next_state = LEFT;
            end
            default: begin
                next_state = LEFT;
            end
        endcase
    end
end

// Output logic
assign walk_left = (current_state == LEFT);
assign walk_right = (current_state == RIGHT);

endmodule