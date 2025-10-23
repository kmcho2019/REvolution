module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;     // p directly samples input a
    q <= p;     // q is always one cycle behind p
end

endmodule