module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state (B=0, A=1)

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B
        out <= 1; // Output is 1 in state B
    end else begin
        case(state)
            1'b0: begin // Current state is B
                if (~in) begin // in is 0
                    state <= 1; // Transition to A
                    out <= 0; // Output is 0 in state A
                end else begin // in is 1
                    state <= 0; // Stay in B
                end
            end
            1'b1: begin // Current state is A
                if (~in) begin // in is 0
                    state <= 0; // Transition to B
                    out <= 1; // Output is 1 in state B
                end else begin // in is 1
                    state <= 1; // Stay in A
                end
            end
        endcase
    end
end

endmodule