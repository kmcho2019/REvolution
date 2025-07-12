// TopModule: A simple state machine driving a constant output value.
module TopModule (
    output logic one
);

// Define the states (only one state is needed for this module)
enum logic {IDLE} state, next_state;

// State machine combinational logic
always_comb begin
    next_state = state; // Since we only have one state, we always stay in it
end

// State machine sequential logic
always_ff @(posedge clk) begin
    state <= next_state;
end

// Output logic based on the state
always_comb begin
    case(state)
        IDLE: one = 1'b1; // Drive 'one' high when in the IDLE state
        default: one = 1'b1; // Default to driving 'one' high
    endcase
end

// Since the module doesn't specify a clock, we need to define one internally or use a default clock if available in the context.
// For simplicity, let's assume an internal clock generator, which in a real design would be more sophisticated.
logic clk;
always begin
    #5ns; // Assume a 100 MHz clock for simplicity
    clk = ~clk;
end

initial begin
    state = IDLE; // Initialize the state machine to the IDLE state
    clk = 0; // Initialize the internal clock
end

endmodule