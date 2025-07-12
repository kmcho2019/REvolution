module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1; // Reset to state B (out=1)
    end else begin
        case(state)
            1'b0: // State A (out=0)
                state <= in ? 1'b0 : 1'b1; // in=1 -> A, in=0 -> B
            1'b1: // State B (out=1)
                state <= in ? 1'b1 : 1'b0; // in=1 -> B, in=0 -> A
        endcase
    end
end

assign out = ~state; // Output is directly related to the state

endmodule