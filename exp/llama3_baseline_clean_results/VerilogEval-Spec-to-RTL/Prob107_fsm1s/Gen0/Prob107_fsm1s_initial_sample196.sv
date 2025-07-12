module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state register

// Define the next state logic
always @(*) begin
    case(state)
        1'b1: // State B
            if (~in) begin
                out = 1'b1; // out in state B
            end else begin
                out = 1'b1; // out in state B
            end
        1'b0: // State A
            if (~in) begin
                out = 1'b0; // out in state A
            end else begin
                out = 1'b0; // out in state A
            end
    endcase
end

// Define the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset state is B
    end else begin
        case(state)
            1'b1: // State B
                if (~in) begin
                    state <= 1'b0; // Transition to A
                end else begin
                    state <= 1'b1; // Stay in B
                end
            1'b0: // State A
                if (~in) begin
                    state <= 1'b1; // Transition to B
                end else begin
                    state <= 1'b0; // Stay in A
                end
        endcase
    end
end

endmodule