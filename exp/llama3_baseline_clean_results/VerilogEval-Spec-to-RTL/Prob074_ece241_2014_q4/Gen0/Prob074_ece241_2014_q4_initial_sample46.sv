module TopModule(clk, x, z);
    input clk;
    input x;
    output z;
    reg xor_ff, and_ff, or_ff;

    // Initialize flip-flops to zero
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff = 0;
    end

    // D flip-flops with asynchronous reset
    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;
        and_ff <= x & ~and_ff;
        or_ff <= x | ~or_ff;
    end

    // Compute output z
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule