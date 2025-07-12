module TopModule(
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;
    // else: latch holds value implicitly, no assignment needed
end

endmodule