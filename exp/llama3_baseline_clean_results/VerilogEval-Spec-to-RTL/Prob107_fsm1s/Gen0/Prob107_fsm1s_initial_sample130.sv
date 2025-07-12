// Define the states as an enumeration
typedef enum logic [0:0] {
    B,
    A
} state_t;

module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

state_t state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B; // Default to B if state is unknown
    endcase
end

// Sequential logic to update the state and output based on the current state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to assign the output based on the current state
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0; // Default output to 0 if state is unknown
    endcase
end

endmodule