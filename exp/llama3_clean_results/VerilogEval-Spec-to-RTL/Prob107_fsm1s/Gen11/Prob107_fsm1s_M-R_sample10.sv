module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter STATE_B = 0, STATE_A = 1;
reg [0:0] state; // Current state

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset state is B
    end else begin
        case(state)
            STATE_B: state <= (in == 0) ? STATE_A : STATE_B;
            STATE_A: state <= (in == 0) ? STATE_B : STATE_A;
            default: state <= STATE_B; // Default to state B
        endcase
    end
end

assign out = (state == STATE_B) ? 1'b1 : 1'b0; // Output is 1 in state B and 0 in state A

endmodule