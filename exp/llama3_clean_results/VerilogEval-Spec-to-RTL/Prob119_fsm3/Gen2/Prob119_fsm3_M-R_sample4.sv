module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as one-hot values
reg [3:0] state;

// Assign output based on current state
assign out = state[3]; // Output is 1 only in state D (one-hot encoding)

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001; // Reset to state A
    end else begin
        case (1'b1) // Using one-hot encoding, find which bit is set
            state[0]: state <= in ? 4'b0010 : 4'b0001; // From state A
            state[1]: state <= in ? 4'b0010 : 4'b0100; // From state B
            state[2]: state <= in ? 4'b1000 : 4'b0001; // From state C
            state[3]: state <= in ? 4'b0010 : 4'b0100; // From state D
            default: state <= 4'b0001; // Default to state A if none of the above
        endcase
    end
end

endmodule