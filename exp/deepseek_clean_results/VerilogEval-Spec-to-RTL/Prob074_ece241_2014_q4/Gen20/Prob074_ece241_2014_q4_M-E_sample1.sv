module TopModule (
    input clk,
    input x,
    output z
);

    // Internal signals
    reg [1:0] startup_cnt = 2'b0;
    wire internal_reset;
    reg xor_ff, and_ff, or_ff;
    wire xor_in, and_in, or_in;
    reg xor_pipe, and_pipe, or_pipe;

    // Power-on reset counter
    always @(posedge clk) begin
        if (startup_cnt != 2'b11)
            startup_cnt <= startup_cnt + 1;
    end
    assign internal_reset = (startup_cnt != 2'b11);

    // Gate logic with pipelining
    assign xor_in = x ^ xor_ff;
    assign and_in = x & ~and_ff;
    assign or_in  = x | ~or_ff;

    // Pipeline stage
    always @(posedge clk) begin
        xor_pipe <= xor_in;
        and_pipe <= and_in;
        or_pipe  <= or_in;
    end

    // Flip-flops with internal reset
    always @(posedge clk) begin
        if (internal_reset) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= xor_pipe;
            and_ff <= and_pipe;
            or_ff  <= or_pipe;
        end
    end

    // Structural 3-input NOR implementation
    wire nor1, nor2;
    nor(nor1, xor_ff, and_ff);
    nor(nor2, nor1, or_ff);
    assign z = nor2;

endmodule