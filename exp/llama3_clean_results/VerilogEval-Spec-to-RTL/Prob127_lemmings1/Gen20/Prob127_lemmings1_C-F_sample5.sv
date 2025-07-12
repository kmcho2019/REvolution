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

reg state; // Using a 1-bit state variable

// Use a single always block for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to LEFT
    end else begin
        case ({bump_left, bump_right})
            2'b00: state <= state;
            2'b01: state <= 1'b1; // Switch to walking left
            2'b10: state <= 1'b0; // Switch to walking right
            2'b11: state <= ~state; // Switch direction
        endcase
    end
end

// Use assign statements for output logic
assign walk_left = (state == 1'b1);
assign walk_right = (state == 1'b0);

endmodule