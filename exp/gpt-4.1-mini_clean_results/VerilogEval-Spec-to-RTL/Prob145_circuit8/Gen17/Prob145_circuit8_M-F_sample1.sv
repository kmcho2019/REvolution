module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    // On rising clock edge, update p based on a and current p,q
    // Trying a function that fits waveform: p <= a | (p & q);
    // This means p goes high if a=1 or if both p and q were 1 (holding state)
    p <= a | (p & q);
end

always @(negedge clock) begin
    // On falling clock edge, update q to previous p
    q <= p;
end

endmodule