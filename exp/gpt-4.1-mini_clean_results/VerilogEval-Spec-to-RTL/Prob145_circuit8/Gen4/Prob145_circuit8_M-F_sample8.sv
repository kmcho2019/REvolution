module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;  // unknown initial state as in waveform
    q = 1'bx;
end

// On rising clock edge, p samples input 'a'
always @(posedge clock) begin
    p <= a;
end

// On falling clock edge, q samples p
always @(negedge clock) begin
    q <= p;
end

endmodule