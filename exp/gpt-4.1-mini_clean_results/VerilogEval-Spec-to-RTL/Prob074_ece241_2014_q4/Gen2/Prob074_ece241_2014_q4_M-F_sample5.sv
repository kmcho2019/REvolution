module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal asynchronous active-low reset signal, asserted on power-up
    reg [3:0] reset_shift = 4'b0000;
    wire rst_n;

    // Generate an internal asynchronous reset that stays active low for first 4 clocks
    // Shift in 1's at each clock; after 4 cycles rst_n deasserts (goes high)
    always @(posedge clk) begin
        reset_shift <= {reset_shift[2:0], 1'b1};
    end
    assign rst_n = reset_shift[3];

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // Combinational D input signals for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule