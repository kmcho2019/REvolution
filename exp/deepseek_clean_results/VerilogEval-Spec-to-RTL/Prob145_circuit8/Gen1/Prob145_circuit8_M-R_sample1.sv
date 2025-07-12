module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is high only when both clock and a are high
assign p = clock & a;

// q stores p's value from previous positive clock edge
always @(posedge clock) begin
    q <= p;
end

endmodule