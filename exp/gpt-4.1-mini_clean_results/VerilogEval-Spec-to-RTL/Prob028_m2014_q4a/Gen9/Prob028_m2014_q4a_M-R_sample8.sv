module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q <= d;
    // else no assignment implies latch holds previous state
end

endmodule