module TopModule(
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d; // blocking assignment to infer latch behavior
    // else retain previous q value
end

endmodule