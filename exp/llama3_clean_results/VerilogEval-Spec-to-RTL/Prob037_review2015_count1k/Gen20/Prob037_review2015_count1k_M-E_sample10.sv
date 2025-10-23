module LFSR(
    input clk,
    input reset,
    output [9:0] pwm_signal
);

parameter WIDTH = 10;

reg [WIDTH-1:0] lfsr_register;
reg [WIDTH-1:0] pwm_output;

always @(posedge clk) begin
    if (reset) begin
        lfsr_register <= 'd1;
    end else begin
        lfsr_register <= {lfsr_register[WIDTH-2:0], lfsr_register[WIDTH-1] ^ lfsr_register[WIDTH-2]};
    end
end

assign pwm_signal = (lfsr_register[WIDTH-1] == 1'b1) ? 10'd1 : 10'd0;

endmodule

module Counter(
    input clk,
    input reset,
    input pwm_signal,
    output [9:0] count
);

reg [9:0] accumulator;

always @(posedge clk) begin
    if (reset) begin
        accumulator <= 'd0;
    end else if (pwm_signal == 1'b1) begin
        accumulator <= accumulator + 1'b1;
    end
end

assign count = accumulator;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

LFSR lfsr_instance(
    .clk(clk),
    .reset(reset),
    .pwm_signal(q)
);

Counter counter_instance(
    .clk(clk),
    .reset(reset),
    .pwm_signal(q[0]),
    .count(q)
);

endmodule