module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor;
    reg q_and;
    reg q_or;

    // Initialize flip-flops to zero at simulation start
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Combinational logic for next D inputs
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops updating on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
    end

    always @(posedge clk) begin
        q_and <= d_and;
    end

    always @(posedge clk) begin
        q_or <= d_or;
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule