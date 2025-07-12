module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the state registers
reg state_A;
reg state_B;

// Determine the output based on the current states
assign out = state_B ? 1'b1 : 1'b0;

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state_A <= 1'b0;
        state_B <= 1'b1;
    end else begin
        case({state_A, state_B})
            2'b01: begin // State A
                state_A <= in ? 1'b1 : 1'b0;
                state_B <= in ? 1'b0 : 1'b1;
            end
            2'b10: begin // State B
                state_A <= in ? 1'b0 : 1'b1;
                state_B <= in ? 1'b1 : 1'b0;
            end
            default: begin // Invalid state, reset to state B
                state_A <= 1'b0;
                state_B <= 1'b1;
            end
        endcase
    end
end

endmodule