module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Qnext;

assign Qnext = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    // Update Q only if J or K is not zero to reduce unnecessary toggling
    if (j | k)
        Q <= Qnext;
    // else: no assignment, retain Q (no toggle)
end

endmodule