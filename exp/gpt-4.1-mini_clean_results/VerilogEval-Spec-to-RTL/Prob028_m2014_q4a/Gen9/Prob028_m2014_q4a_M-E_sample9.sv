module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q <= d;  // transparent when enabled
    // else hold previous value (latch)
end

endmodule