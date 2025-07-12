module TopModule (
    input  clk,
    input  x,
    output z
);
    reg [2:0] q; // [2] = xor, [1] = and, [0] = or
    reg init_done;

    // Synchronous reset logic to initialize flip-flops to 0 at the first clock
    always @(posedge clk) begin
        if (!init_done) begin
            q <= 3'b000;
            init_done <= 1'b1;
        end else begin
            q[2] <= x ^ q[2];      // XOR flip-flop D input
            q[1] <= x & ~q[1];     // AND flip-flop D input
            q[0] <= x | ~q[0];     // OR flip-flop D input
        end
    end

    assign z = ~(q[2] | q[1] | q[0]);

endmodule