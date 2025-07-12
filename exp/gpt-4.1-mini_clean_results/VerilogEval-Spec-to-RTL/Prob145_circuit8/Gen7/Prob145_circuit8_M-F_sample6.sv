module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

initial begin
    p = 1'b0;
    q = 1'b0;
end

// At rising edge: p <= a OR q
always @(posedge clock) begin
    p <= a | q;
end

// At falling edge: q <= p
always @(negedge clock) begin
    q <= p;
end

endmodule