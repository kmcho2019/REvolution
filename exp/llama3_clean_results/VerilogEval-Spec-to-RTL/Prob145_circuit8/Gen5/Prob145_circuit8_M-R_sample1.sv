module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    p <= a;
    prev_p <= p;
end

assign q = (~clock) ? (a ? 0 : (prev_p ? 1 : q)) : q;

endmodule