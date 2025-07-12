module TopModule(
    input  clk,
    input  d,
    output q
);

reg clk_int;
reg q_int;
reg q_next;

// generate an internal clock that runs twice as fast as the input clock
// this is a common technique when dealing with dual-edge triggered flip-flops
always @(posedge clk or negedge clk) begin
    clk_int <= ~clk_int;
end

// use the internal clock to update the output
always @(posedge clk_int) begin
    q_int <= d;
end

// use the original clock to sample the output of the internal flip-flop
always @(posedge clk or negedge clk) begin
    q <= q_int;
end

assign q_next = q_int;

endmodule