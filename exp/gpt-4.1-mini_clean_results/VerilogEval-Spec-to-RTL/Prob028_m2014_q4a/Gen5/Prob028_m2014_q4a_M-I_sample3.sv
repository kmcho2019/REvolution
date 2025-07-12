module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q <= d;  // Non-blocking assignment for latch inference
    // else hold previous q (no assignment)
end

initial q = 1'b0;  // Optional: Initialize for simulation

endmodule