`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// One-Hot state encoding: A=1000, B=0100, C=0010, D=0001
reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        case (1'b1)
            state[3]: state <= in? 4'b0100 : 4'b1000; // A to B or stay in A
            state[2]: state <= in? 4'b0100 : 4'b0010; // B to B or C
            state[1]: state <= in? 4'b0001 : 4'b1000; // C to D or A
            state[0]: state <= in? 4'b0100 : 4'b0010; // D to B or C
        endcase
    end
end

// Output logic based on the state
assign out = state[0]; // Output is 1 only when in state D

endmodule