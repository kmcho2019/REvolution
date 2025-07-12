`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] current_state;
reg [3:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 4'b0001;
    end else begin
        current_state <= next_state;
    end
end

assign next_state[0] = (current_state[0] &&!in) || (current_state[2] &&!in);
assign next_state[1] = (current_state[0] && in) || (current_state[1] && in);
assign next_state[2] = current_state[1] &&!in;
assign next_state[3] = current_state[2] && in;

assign out = current_state[3];

endmodule