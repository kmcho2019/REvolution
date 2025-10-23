module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end

    // Optional initial block for simulation clarity (can be removed if synthesis target doesn't support)
    initial begin
        Q = 1'b0;
    end

endmodule