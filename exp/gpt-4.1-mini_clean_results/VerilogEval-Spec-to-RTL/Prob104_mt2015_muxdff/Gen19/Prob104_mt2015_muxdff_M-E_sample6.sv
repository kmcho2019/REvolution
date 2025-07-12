module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // Internal register to simulate reset on startup without using initial block
    reg init_done = 1'b0;

    always @(posedge clk) begin
        if (!init_done) begin
            // Initialize Q on first clock edge to zero
            Q <= 1'b0;
            init_done <= 1'b1;
        end else begin
            // Load r_in if L is asserted; else shift q_in
            if (L)
                Q <= r_in;
            else
                Q <= q_in;
        end
    end

endmodule