module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding for two states
wire next_z; // Next output z

// One-hot encoding: A = 2'b01, B = 2'b10

// Combinational logic for next state and output
always @(*) begin
    case (state)
        2'b01: // State A
            begin
                if (x == 1'b0) begin
                    next_z = 1'b0;
                    state <= 2'b01; // Stay in A
                end else begin
                    next_z = 1'b1;
                    state <= 2'b10; // Move to B
                end
            end
        2'b10: // State B
            begin
                next_z = ~x; // z is the inverse of x in state B
                state <= 2'b10; // Stay in B
            end
        default: // Should not happen in one-hot encoding
            begin
                next_z = 1'b0; // Default z
                state <= 2'b01; // Reset to A
            end
    endcase
end

// Sequential logic (register) to store the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
        z <= 1'b0; // Reset output z
    end else begin
        // Update state on clock edge
        state <= state;
        // Update output z
        z <= next_z;
    end
end

// Continuous assignment for output z (to match always block output z)
assign z = next_z;

endmodule