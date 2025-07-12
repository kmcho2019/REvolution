module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena)
        q = d;
    // else: no assignment to q, so latch holds previous value
end

endmodule