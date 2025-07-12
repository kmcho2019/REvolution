module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define an enumeration for the states
typedef enum logic [1:0] {LEFT = 2'b00, RIGHT = 2'b01} state_t;

state_t state, next_state; // Using a 2-bit state variable

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
    end else begin
        state <= next_state;
    end
end

// Use always block for combinational logic
always @(*) begin
    case (state)
        LEFT: next_state = (bump_left) ? RIGHT : LEFT;
        RIGHT: next_state = (bump_right) ? LEFT : RIGHT;
        default: next_state = LEFT;
    endcase
end

// Use assign statements for output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule