module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] nextState; // Next state
reg zNext; // Next output z

// Combinational logic for next state and output
always @(*) begin
    case (state)
        2'b10: begin // State A
            if (~x) begin // x = 0
                nextState = 2'b10; // Stay in A
                zNext = 1'b0; // z = 0
            end else begin // x = 1
                nextState = 2'b01; // Go to B
                zNext = 1'b1; // z = 1
            end
        end
        2'b01: begin // State B
            if (~x) begin // x = 0
                nextState = 2'b01; // Stay in B
                zNext = 1'b1; // z = 1
            end else begin // x = 1
                nextState = 2'b01; // Stay in B
                zNext = 1'b0; // z = 0
            end
        end
        default: begin // Invalid state, should not happen
            nextState = 2'b10; // Reset to A
            zNext = 1'b0; // z = 0
        end
    endcase
end

// Sequential logic for state update and output
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 2'b10; // Reset to state A
        z <= 1'b0; // Reset output z to 0
    end else begin
        state <= nextState; // Update state
        z <= zNext; // Update output z
    end
end

endmodule