module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 1-bit variable to hold the state (A=0, B=1)

// Directly assign the output based on the current state
always @(*) begin
    case(state)
        1'b0: out = 1'b0; // State A, out = 0
        1'b1: out = 1'b1; // State B, out = 1
    endcase
end

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: state <= in? 1'b0 : 1'b1; // From A, in=0 -> B, in=1 -> A
            1'b1: state <= in? 1'b1 : 1'b0; // From B, in=0 -> A, in=1 -> B
        endcase
    end
end

endmodule