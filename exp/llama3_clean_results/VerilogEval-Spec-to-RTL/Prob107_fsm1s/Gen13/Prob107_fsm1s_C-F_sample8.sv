module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter RESET_STATE = 1; // Define the reset state as a parameter, set to 1 according to the problem description

reg [0:0] state; // 1-bit state variable, initialized as 1 bit wide for clarity

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= RESET_STATE; // Reset to the defined reset state
        out <= 1; // According to the problem, in state B, out should be 1
    end else begin
        case(state)
            1'b0: begin // State A
                if(~in) state <= 1'b1; // If in is 0, move to state B
                else state <= 1'b0; // If in is 1, stay in state A
                out <= 1'b0; // In state A, out is 0
            end
            1'b1: begin // State B
                if(~in) state <= 1'b0; // If in is 0, move to state A
                else state <= 1'b1; // If in is 1, stay in state B
                out <= 1'b1; // In state B, out is 1
            end
        endcase
    end
end

endmodule