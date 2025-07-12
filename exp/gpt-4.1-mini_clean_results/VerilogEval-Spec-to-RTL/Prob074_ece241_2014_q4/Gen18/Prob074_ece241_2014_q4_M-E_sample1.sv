module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal reset generator: hold reset active for first 2 clock cycles after power-up
    reg [1:0] reset_counter = 2'b11;
    wire reset = |reset_counter; // reset active while any bit in reset_counter is 1

    always @(posedge clk) begin
        if (reset_counter != 0)
            reset_counter <= reset_counter - 1'b1;
    end

    // State registers for flip-flops
    reg q_xor, q_and, q_or;

    // Combinational logic for D inputs
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential update with synchronous reset
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

    // Output: NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule