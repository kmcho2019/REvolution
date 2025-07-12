module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;   // Transparent when enabled
    else
        q = q;   // Hold value when not enabled
end

endmodule