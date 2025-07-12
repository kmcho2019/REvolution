module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    p <= a;  // p follows 'a' only at clock edges
    q <= prev_p & ~a;  // q is set when previous p was high and current a is low
    prev_p <= p;  // store previous p value
end

endmodule