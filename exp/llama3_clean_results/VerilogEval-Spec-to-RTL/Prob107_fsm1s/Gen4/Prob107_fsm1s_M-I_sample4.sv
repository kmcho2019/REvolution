module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Sequential logic for state transitions and output assignment
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1;
    end else begin
        case(state)
            1'b0: begin // State A
                if(in == 1'b0) begin
                    state <= 1'b1; // Transition to state B
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // Stay in state A
                    out <= 1'b0;
                end
            end
            1'b1: begin // State B
                if(in == 1'b0) begin
                    state <= 1'b0; // Transition to state A
                    out <= 1'b0;
                end else begin
                    state <= 1'b1; // Stay in state B
                    out <= 1'b1;
                end
            end
        endcase
    end
end

endmodule