module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;
    wire z_temp;

    // Synchronous reset implementation
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff = 0;
    end

    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;
        and_ff <= x & ~and_ff;
        or_ff  <= x | ~or_ff;
    end

    // Alternative NOR implementation that might optimize better
    assign z = ~xor_ff & ~and_ff & ~or_ff;

endmodule