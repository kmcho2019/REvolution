module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// No initial block to reflect 'x' initial states as per waveform

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    q <= p;
end

endmodule