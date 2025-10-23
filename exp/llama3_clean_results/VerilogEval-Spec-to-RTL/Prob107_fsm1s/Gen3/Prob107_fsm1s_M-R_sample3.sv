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
        out <= 1; // Output in reset state B
    end else begin
        case(state)
            1'b0: begin // State B
                out <= 1; // Output in state B
                if(!in) begin
                    state <= 1; // State B with in=0, go to state A
                end
            end
            1'b1: begin // State A
                out <= 0; // Output in state A
                if(!in) begin
                    state <= 0; // State A with in=0, go to state B
                end
            end
        endcase
    end
end

endmodule