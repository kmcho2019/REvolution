module TopModule(
    input       clk,
    input       areset,
    input       in,
    output      out
);

reg [0:0] state, next_state;

// Define the states
localparam A = 0, B = 1;

// Combinational logic for next state and output
always_comb begin
    case(state)
        A: next_state = (in == 0) ? B : A;
        B: next_state = (in == 0) ? A : B;
        default: next_state = B; // Default to B
    endcase
    out = state; // Assuming output directly corresponds to the state
end

// Sequential logic for state register
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= B; // Asynchronously reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule