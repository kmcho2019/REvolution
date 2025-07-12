module TopModule(
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;
    // else hold q implicitly
end

endmodule