module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state;

initial state = 1'b1; // Initialize state to B

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: begin // State A
                if (~in) begin
                    state <= 1'b1; // Transition to state B
                end
            end
            1'b1: begin // State B
                if (~in) begin
                    state <= 1'b0; // Transition to state A
                end
            end
        endcase
    end
end

always @(state) begin
    case(state)
        1'b0: out = 1'b0; // Output is 0 in state A
        1'b1: out = 1'b1; // Output is 1 in state B
    endcase
end

endmodule