module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena)
        q <= d;
    else
        q <= q;  // Explicitly hold previous value to infer latch cleanly
end

endmodule