module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(posedge clock) begin
    if (a) q <= 1'b1;
end

// Alternatively, you could use the following to directly set q based on a and its current state
// always @(posedge clock) begin
//     if (a) q <= 1'b1; else q <= q;
// end

initial begin
    q = 1'b0;
end

endmodule