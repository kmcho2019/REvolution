`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] state;
reg [3:0] next_state;

initial state = 4'b0001; // Initialize state to A

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset state to A
    end else begin
        state <= next_state;
    end
end

assign next_state = (state == 4'b0001) ? (in ? 4'b0010 : 4'b0001) : // State A
                    (state == 4'b0010) ? (in ? 4'b0010 : 4'b0100) : // State B
                    (state == 4'b0100) ? (in ? 4'b1000 : 4'b0001) : // State C
                    (state == 4'b1000) ? (in ? 4'b0010 : 4'b0100) : 4'b0000; // State D

assign out = state[3]; // Output is '1' when state is D (4'b1000)

endmodule