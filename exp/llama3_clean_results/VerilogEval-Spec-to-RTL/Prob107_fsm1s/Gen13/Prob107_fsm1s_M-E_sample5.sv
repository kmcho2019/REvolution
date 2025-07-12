module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // 2-bit state variable (0 = B, 1 = A)
reg [1:0] next_state; // 2-bit next state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 0; // Reset to state B
        out <= 1; // Reset output to 1
    end else begin
        case ({state, in})
            2'b00: begin // State B, in = 0
                state <= 1; // Next state A
                out <= 0; // Output 0
            end
            2'b01: begin // State B, in = 1
                state <= 0; // Next state B
                out <= 1; // Output 1
            end
            2'b10: begin // State A, in = 0
                state <= 0; // Next state B
                out <= 1; // Output 1
            end
            2'b11: begin // State A, in = 1
                state <= 1; // Next state A
                out <= 0; // Output 0
            end
        endcase
    end
end

endmodule