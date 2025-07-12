module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as one-hot signals
reg [3:0] state;

// Assign output based on current state
assign out = state[3];

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b1000; // Reset to state A (one-hot encoding)
    end else begin
        case (1'b1) // Use one-hot encoding to simplify the case statement
            state[0]: state <= in ? 4'b0100 : 4'b1000; // State A
            state[1]: state <= in ? 4'b0100 : 4'b0010; // State B
            state[2]: state <= in ? 4'b0001 : 4'b1000; // State C
            state[3]: state <= in ? 4'b0100 : 4'b0010; // State D
        endcase
    end
end

endmodule