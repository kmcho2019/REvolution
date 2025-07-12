`timescale 1ns/1ps

module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

localparam STATE_A = 4'b0001;
localparam STATE_B = 4'b0010;
localparam STATE_C = 4'b0100;
localparam STATE_D = 4'b1000;

logic [3:0] state;
logic [3:0] next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        STATE_A: next_state = in ? STATE_B : STATE_A;
        STATE_B: next_state = in ? STATE_B : STATE_C;
        STATE_C: next_state = in ? STATE_D : STATE_A;
        STATE_D: next_state = in ? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

assign out = (state == STATE_D);

endmodule