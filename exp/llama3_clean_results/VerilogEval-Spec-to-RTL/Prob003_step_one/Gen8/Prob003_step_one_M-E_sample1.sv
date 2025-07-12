module TopModule (
    output one
);

// Define the state of the FSM (not actually used due to the nature of the problem)
reg [0:0] state;

// Always block to define the next state and output logic
always @(*) begin
    // Since we're always in the same state, next_state is the same as current state
    // For simplicity, let's assume the state is 1 (which is not actually used)
    state = 1'b1;
    
    // Output logic: always drive 1
    one = 1'b1;
end

// Initial block to initialize the state (if needed)
initial begin
    state = 1'b1;
end

endmodule