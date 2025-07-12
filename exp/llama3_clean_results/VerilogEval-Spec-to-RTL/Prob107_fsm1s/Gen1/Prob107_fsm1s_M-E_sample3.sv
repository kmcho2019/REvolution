module TopModule(
    input clk,
    input reset,
    input in,
    output reg out // Declare 'out' as a reg
);

reg [0:0] state; // Using a 1-bit register to represent the state

// Look-up table (LUT) for next state and output
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out <= 1; // Reset output is 1
    end else begin
        case({state, in})
            2'b00: begin // State B, input 0
                state <= 1; // Go to state A
                out <= 0; // Output 0
            end
            2'b01: begin // State B, input 1
                state <= 0; // Stay in state B
                out <= 1; // Output 1
            end
            2'b10: begin // State A, input 0
                state <= 0; // Go to state B
                out <= 1; // Output 1
            end
            2'b11: begin // State A, input 1
                state <= 1; // Stay in state A
                out <= 0; // Output 0
            end
        endcase
    end
end

endmodule