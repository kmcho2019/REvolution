// Stage module for the LFSR
module LFSR_Stage(
    input clk, // Clock signal
    input rst, // Active high reset signal
    input bit_in, // Input bit
    output reg bit_out // Output bit
);

always @ (posedge clk) begin
    if (rst) begin
        bit_out <= 1'b0;
    end else begin
        bit_out <= bit_in;
    end
end

endmodule

// Feedback calculation module
module Feedback(
    input [3:0] state, // Current state of the LFSR
    output reg feedback // Feedback signal
);

assign feedback = ~(state[3] ^ state[2]);

endmodule

// Top-level LFSR module
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

wire [2:0] stage_out; // Output of each stage
wire feedback; // Feedback signal

// Instantiate the stages
LFSR_Stage stage_0(
    .clk(clk),
    .rst(rst),
    .bit_in(feedback),
    .bit_out(out[0])
);

LFSR_Stage stage_1(
    .clk(clk),
    .rst(rst),
    .bit_in(out[0]),
    .bit_out(out[1])
);

LFSR_Stage stage_2(
    .clk(clk),
    .rst(rst),
    .bit_in(out[1]),
    .bit_out(out[2])
);

LFSR_Stage stage_3(
    .clk(clk),
    .rst(rst),
    .bit_in(out[2]),
    .bit_out(out[3])
);

// Instantiate the feedback calculation module
Feedback feedback_module(
    .state(out),
    .feedback(feedback)
);

endmodule

// Example testbench to verify the LFSR module
module tb_LFSR;
reg clk, rst;
wire [3:0] out;

LFSR uut (.clk(clk), .rst(rst), .out(out));

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    #100;
    $finish;
end

endmodule