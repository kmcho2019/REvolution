module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;

    // Internal asynchronous reset signal to initialize flip-flops on power-up
    // This uses a small power-on-reset sequence lasting a few cycles.
    reg [3:0] por_count = 4'b1111;  // 4 cycles reset duration at start
    wire reset = (por_count != 0);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & ~q_and;
            q_or  <= x | ~q_or;
        end
    end

    // Countdown for power-on reset
    always @(posedge clk) begin
        if (por_count != 0)
            por_count <= por_count - 1;
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule