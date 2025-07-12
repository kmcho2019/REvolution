module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define the states as an enumeration for better readability
typedef enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100
} state_type;

// Current and next state variables
state_type y, next_y;

// Sequential logic for state transitions
always_ff @(posedge clk) begin
    if (reset) begin
        y <= S000; // Synchronous active high reset
    end else begin
        y <= next_y; // Update state on positive edge of clk
    end
end

// Combinational logic for next state and output z
always_comb begin
    case (y)
        S000: next_y = (x) ? S001 : S000;
        S001: next_y = (x) ? S100 : S001;
        S010: next_y = (x) ? S001 : S010;
        S011: next_y = (x) ? S010 : S001;
        S100: next_y = (x) ? S100 : S011;
        default: next_y = S000; // Default to initial state if not handled
    endcase

    // Output z logic
    case (y)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0; // Default output if not handled
    endcase
end

endmodule