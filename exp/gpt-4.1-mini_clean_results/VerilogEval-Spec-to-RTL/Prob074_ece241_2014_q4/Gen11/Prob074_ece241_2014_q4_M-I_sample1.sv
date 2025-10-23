module TopModule (
    input  clk,
    input  x,
    output z
);
    // Synchronous reset generation logic - hold reset active for first 4 clock cycles after power-up
    reg [2:0] reset_counter = 3'b111; // initialize to non-zero to hold reset active initially
    reg reset;
    always @(posedge clk) begin
        if (reset_counter != 3'b000)
            reset_counter <= reset_counter - 1'b1;
        reset <= (reset_counter != 3'b000);
    end

    // Current state registers for each flip-flop
    reg q_xor;
    reg q_and;
    reg q_or;

    // Next state wires - D inputs to flip-flops
    wire d_xor;
    wire d_and;
    wire d_or;

    // Combinational logic for next state based on current state and input x
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Flip-flops with synchronous reset on positive clock edge
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

    // Output z is the NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule