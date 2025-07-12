module TopModule (
    input        clk,
    input        L,
    input        q_in,
    input        r_in,
    output reg   Q
);

    // On rising edge of clk:
    // If load enable (L) is high, load Q with r_in
    // Otherwise, update Q with q_in (the feedback or hold value)
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

endmodule