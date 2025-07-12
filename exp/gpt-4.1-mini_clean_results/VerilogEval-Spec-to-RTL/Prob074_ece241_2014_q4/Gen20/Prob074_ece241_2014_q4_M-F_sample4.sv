module TopModule (
    input  clk,
    input  x,
    output z
);

    // Asynchronous reset synchronizer for power-on reset (active low)
    reg reset_n_ff1 = 1'b0;
    reg reset_n_ff2 = 1'b0;
    wire reset_n;

    // Power-on reset signal: initially 0, released after two clocks synchronously
    always @(posedge clk or negedge reset_n_ff1) begin
        if (!reset_n_ff1)
            reset_n_ff2 <= 1'b0;
        else
            reset_n_ff2 <= 1'b1;
    end

    always @(posedge clk or negedge reset_n_ff1) begin
        if (!reset_n_ff1)
            reset_n_ff1 <= 1'b0;
        else
            reset_n_ff1 <= 1'b1;
    end

    assign reset_n = reset_n_ff2;

    // Flip-flop outputs
    reg ff_xor, ff_and, ff_or;

    // D inputs computed explicitly
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Flip-flops with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    // Output is NOR of the flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule