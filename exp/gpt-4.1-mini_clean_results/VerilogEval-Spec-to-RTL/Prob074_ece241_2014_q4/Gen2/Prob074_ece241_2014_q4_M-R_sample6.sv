module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // Power-on reset counter (holds reset active for 7 clock cycles)
    reg [2:0] reset_cnt = 3'd0;
    wire reset = (reset_cnt != 3'd7);

    // Increment reset counter on each clock cycle until max count reached
    always @(posedge clk) begin
        if (reset_cnt != 3'd7)
            reset_cnt <= reset_cnt + 1'b1;
    end

    // Compute combinational inputs for flip-flops (D inputs)
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential logic: flip-flops update on rising clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule