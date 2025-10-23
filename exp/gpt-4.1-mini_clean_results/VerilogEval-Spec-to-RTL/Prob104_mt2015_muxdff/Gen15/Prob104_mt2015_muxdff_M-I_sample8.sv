module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // On rising edge of clk, load Q with r_in if L=1; else update Q with q_in
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule