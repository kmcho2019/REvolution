module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q = 1'b0  // Initialize Q to 0 for known startup state
);

// On clock rising edge, load r_in if L=1, else q_in
always @(posedge clk) begin
    if (L)
        Q <= r_in;
    else
        Q <= q_in;
end

endmodule