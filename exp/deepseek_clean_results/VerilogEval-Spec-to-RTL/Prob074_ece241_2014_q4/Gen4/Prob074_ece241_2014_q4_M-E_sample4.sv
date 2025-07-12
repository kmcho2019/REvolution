module TopModule (
    input clk,
    input x,
    output z
);

    // Internal signals
    reg xor_ff, and_ff, or_ff;
    wire xor_fb, and_fb, or_fb;
    wire xor_in, and_in, or_in;

    // Feedback paths
    assign xor_fb = xor_ff;
    assign and_fb = ~and_ff;
    assign or_fb = ~or_ff;

    // Gate operations
    assign xor_in = x ^ xor_fb;
    assign and_in = x & and_fb;
    assign or_in = x | or_fb;

    // Flip-flop with synchronous reset
    always @(posedge clk) begin
        xor_ff <= xor_in;
    end

    always @(posedge clk) begin
        and_ff <= and_in;
    end

    always @(posedge clk) begin
        or_ff <= or_in;
    end

    // Initialization with synchronous reset
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff = 0;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule