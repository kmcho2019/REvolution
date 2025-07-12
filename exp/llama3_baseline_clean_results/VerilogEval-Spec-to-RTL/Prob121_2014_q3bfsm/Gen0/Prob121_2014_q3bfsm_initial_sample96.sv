module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define an enumeration for the states
typedef enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100
} state_t;

// Declare the current and next state variables
state_t current_state, next_state;

// Determine the output z based on the current state
always_comb begin
    case (current_state)
        S000, S001, S010: z = 1'b0;
        S011, S100: z = 1'b1;
        default: z = 1'bx;
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= S000;
    end else begin
        case (current_state)
            S000: current_state <= x ? S001 : S000;
            S001: current_state <= x ? S100 : S001;
            S010: current_state <= x ? S001 : S010;
            S011: current_state <= x ? S010 : S001;
            S100: current_state <= x ? S100 : S011;
            default: current_state <= S000;
        endcase
    end
end

endmodule