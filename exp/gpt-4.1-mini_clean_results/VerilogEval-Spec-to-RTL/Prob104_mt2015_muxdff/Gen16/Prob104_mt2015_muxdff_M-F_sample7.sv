module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // Initialize Q to 0 to avoid unknown state at simulation start
    initial begin
        Q = 1'b0;
    end

    // On rising edge of clk, load Q with r_in if L=1; else update Q with q_in
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule