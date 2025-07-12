module TopModule (
    input clk,
    input x,
    output z
);

    // Internal asynchronous reset signal - starts asserted at power-up
    reg rst = 1'b1;

    // Deassert reset synchronously after first clock edge
    always @(posedge clk) begin
        if (rst)
            rst <= 1'b0;
    end

    // Flip-flop outputs
    reg q_xor;
    reg q_and;
    reg q_or;

    // Combinational inputs to the flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with asynchronous reset (modeled with if(rst) inside always @(posedge clk))
    always @(posedge clk) begin
        if (rst)
            q_xor <= 1'b0;
        else
            q_xor <= d_xor;
    end

    always @(posedge clk) begin
        if (rst)
            q_and <= 1'b0;
        else
            q_and <= d_and;
    end

    always @(posedge clk) begin
        if (rst)
            q_or <= 1'b0;
        else
            q_or <= d_or;
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule