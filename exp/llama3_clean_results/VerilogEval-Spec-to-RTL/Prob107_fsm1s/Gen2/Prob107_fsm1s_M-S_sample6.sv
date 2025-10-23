module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out <= 1; // Reset output is 1
    end else begin
        case(state)
            1'b0: begin // State B
                if (!in) begin
                    state <= 1; // Go to state A
                    out <= 0; // Output 0
                end else begin
                    out <= 1; // Stay in state B, output 1
                end
            end
            1'b1: begin // State A
                if (!in) begin
                    state <= 0; // Go to state B
                    out <= 1; // Output 1
                end else begin
                    out <= 0; // Stay in state A, output 0
                end
            end
        endcase
    end
end

endmodule