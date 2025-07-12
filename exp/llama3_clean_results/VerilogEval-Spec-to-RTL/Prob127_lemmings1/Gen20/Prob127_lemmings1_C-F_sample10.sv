module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define an enumeration for the states
typedef enum {LEFT, RIGHT} state_t;

reg [0:0] state; // Using a 1-bit state variable
reg [0:0] next_state; // Next state variable

// Use an always_comb block for next state logic
always_comb begin
    case (state)
        LEFT: next_state = (bump_left)? RIGHT : LEFT;
        RIGHT: next_state = (bump_right)? LEFT : RIGHT;
        default: next_state = LEFT;
    endcase
end

// Use an always_ff block for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        state <= next_state; // Update state on positive edge of clock
    end
end

// Use a case statement for output logic
always_comb begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule