module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d; // Transparent: when enabled, q follows d
    // else: q retains its value by not assigning anything
end

endmodule