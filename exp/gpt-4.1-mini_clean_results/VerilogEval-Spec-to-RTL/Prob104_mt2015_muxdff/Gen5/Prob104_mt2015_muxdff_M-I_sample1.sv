module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

// Synchronous load of r_in or q_in based on L, on rising edge of clk
always @(posedge clk) begin
    if (L)
        Q <= r_in;
    else
        Q <= q_in;
end

// Note:
// To ensure deterministic simulation and synthesis,
// consider adding a synchronous reset input (e.g. rst) to initialize Q.
// Example:
// input rst;
// always @(posedge clk) begin
//     if (rst)
//         Q <= 1'b0;
//     else if (L)
//         Q <= r_in;
//     else
//         Q <= q_in;
// end

endmodule