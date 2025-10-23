module TopModule (
    input  clk,
    input  x,
    output z
);
    reg [2:0] por_cnt = 3'd0;      // Power-on-reset counter
    reg reset_sync;                // Synchronous reset signal

    // Synchronous reset released after 4 clock cycles
    always @(posedge clk) begin
        if (por_cnt != 3'd4)
            por_cnt <= por_cnt + 1'b1;
        reset_sync <= (por_cnt != 3'd4);
    end

    reg q_xor, q_and, q_or;

    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    always @(posedge clk) begin
        if (reset_sync) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule