module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous active-high reset (ar)
// On assertion of ar, q is immediately cleared to 0 regardless of clk.
// Otherwise, q captures d on the rising edge of clk.
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule