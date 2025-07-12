module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to zero for simulation start to match waveform initial known states
initial begin
    p = 0;
    q = 0;
end

// On rising clock edge, update p with current input a
always @(posedge clock) begin
    p <= a;
end

// On falling clock edge, update q with the current p value
always @(negedge clock) begin
    q <= p;
end

endmodule