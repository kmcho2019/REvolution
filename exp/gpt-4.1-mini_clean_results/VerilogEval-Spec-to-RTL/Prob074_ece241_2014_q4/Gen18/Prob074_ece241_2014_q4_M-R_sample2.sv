module TopModule (
    input  clk,
    input  x,
    output z
);

    // Separate flip-flops for each gate output
    reg xor_ff;
    reg and_ff;
    reg or_ff;

    // Power-on reset generation: active for one cycle after startup
    reg reset;
    reg reset_done;
    always @(posedge clk) begin
        if (!reset_done) begin
            reset <= 1'b1;
            reset_done <= 1'b1;
        end else begin
            reset <= 1'b0;
        end
    end

    // Combinational logic for D inputs
    wire xor_d = x ^ xor_ff;
    wire and_d = x & (~and_ff);
    wire or_d  = x | (~or_ff);

    // Sequential logic: update flip-flops on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end else begin
            xor_ff <= xor_d;
            and_ff <= and_d;
            or_ff  <= or_d;
        end
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule