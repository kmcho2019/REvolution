module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

// p logic: captures 'a' on rising clock edge
always @(posedge clock) begin
    p <= a;
end

// q logic: becomes high if p was high last cycle and a is low now
always @(posedge clock) begin
    p_prev <= p;
    q <= p_prev & ~a;
end

initial begin
    p = 1'b0;
    q = 1'b0;
    p_prev = 1'b0;
end

endmodule