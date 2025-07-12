module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // On rising edge of clk, load r_in if L=1, else load q_in
    // q_in is expected to be the next-state bit computed externally (including any XOR logic)
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule