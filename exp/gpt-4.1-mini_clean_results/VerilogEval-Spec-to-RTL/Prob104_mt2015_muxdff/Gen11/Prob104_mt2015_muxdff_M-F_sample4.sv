module TopModule (
    input        clk,
    input        L,
    input        q_in,
    input        r_in,
    output reg   Q
);

    // On posedge clk, load Q with r_in if L is high; otherwise load Q with q_in
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule