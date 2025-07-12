module TopModule (
    input  d,
    input  ena,
    output reg q
);

// Explicit D latch using blocking assignment and complete always block
always @(ena or d) begin
    if (ena)
        q = d;
    else
        q = q;  // Explicitly hold the previous value
end

endmodule