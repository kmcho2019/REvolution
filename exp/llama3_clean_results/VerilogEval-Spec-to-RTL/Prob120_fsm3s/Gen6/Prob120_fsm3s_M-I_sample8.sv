`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] state; // One-hot encoding

initial state = 4'b0001;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001;
    end else begin
        case (1'b1)
            state[0]: state <= in ? 4'b0010 : 4'b0001;
            state[1]: state <= in ? 4'b0010 : 4'b0100;
            state[2]: state <= in ? 4'b1000 : 4'b0001;
            state[3]: state <= in ? 4'b0010 : 4'b0100;
        endcase
    end
end

assign out = state[3]; // Output is high only when in state D

endmodule