module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    q <= p;  // q follows p with one cycle delay
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;  // clear q when a is high at negedge
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule