module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal synchronous reset generation: assert reset for first 3 clock cycles
    reg [1:0] reset_counter = 2'b11;  // counts down from 3 to 0

    always @(posedge clk) begin
        if (reset_counter != 2'b00)
            reset_counter <= reset_counter - 2'b01;
    end

    wire reset = (reset_counter != 2'b00); // synchronous reset active while counter > 0

    // State flip-flops holding outputs of XOR, AND, OR paths
    reg q_xor, q_and, q_or;

    // Next state logic (combinational)
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential logic with synchronous reset
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