module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*)
begin
    if (ena)
        q <= d; // Capture the value of d when ena is high
    else
        q <= q; // Retain the current value when ena is low
end

endmodule