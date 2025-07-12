module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p directly follows 'a' during clock high
    q <= p;  // q follows p with 1 cycle delay
end

endmodule