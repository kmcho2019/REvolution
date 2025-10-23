module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Positive-edge triggered DFF with async reset
// Implicit clock gating when d is stable for power optimization
always @(posedge clk or posedge ar)
    if (ar)     q <= 1'b0;
    else if (q != d) q <= d;  // Only update when d changes

endmodule