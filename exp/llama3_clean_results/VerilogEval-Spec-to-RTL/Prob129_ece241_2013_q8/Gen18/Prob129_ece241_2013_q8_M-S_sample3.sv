module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
} state_t;

// Define the state register
state_t state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state on asynchronous reset
        state <= S0;
    end else begin
        // State transitions
        case (state)
            S0: if (x) state <= S1; else state <= S0;
            S1: if (!x) state <= S2; else state <= S1;
            S2: if (x) state <= S0; else state <= S0;
            default: state <= S0;
        endcase
    end
end

// Output logic: Assert z when the sequence "101" is detected
assign z = (state == S2) && x;

endmodule