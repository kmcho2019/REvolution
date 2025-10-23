module TopModule (
    input  d,
    input  ena,
    output reg q
);

// Initialize q to 0 for simulation clarity; synthesis tools ignore this
initial q = 1'b0;

// Level-sensitive latch inferred by non-blocking assignment
always @(ena or d) begin
    if (ena)
        q <= d;   // Non-blocking assignment for latch transparency
    else
        q <= q;   // Hold state explicitly to infer latch
end

endmodule