module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to zero to avoid 'x' after simulation start
initial begin
    p = 1'b0;
    q = 1'b0;
end

// Register p updates on rising edge: set to 'a'
always @(posedge clock) begin
    p <= a;
end

// Register q updates on falling edge: sample p
always @(negedge clock) begin
    q <= p;
end

endmodule