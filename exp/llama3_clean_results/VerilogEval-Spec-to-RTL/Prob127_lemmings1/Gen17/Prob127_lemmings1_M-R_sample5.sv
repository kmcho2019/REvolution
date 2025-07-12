module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define an enumeration for the states
typedef enum {LEFT, RIGHT} state_t;

reg state; // Using a 1-bit state variable
reg next_state; // Next state variable

// Use assign statements for combinational logic
assign next_state = (state == LEFT) ? (bump_left ? RIGHT : LEFT) : (bump_right ? LEFT : RIGHT);

// Use an always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        state <= next_state; // Update state on positive edge of clock
    end
end

// Use a case statement for output logic
always @(state) begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule