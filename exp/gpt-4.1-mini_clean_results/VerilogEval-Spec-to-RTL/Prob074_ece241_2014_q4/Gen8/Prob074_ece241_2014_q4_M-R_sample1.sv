module TopModule (
    input  clk,
    input  x,
    output z
);

    // State register holding flip-flops q_xor, q_and, q_or
    reg [2:0] state;

    // Internal reset asserted only on first clock cycle after power-up
    reg init_done;

    wire q_xor = state[2];
    wire q_and = state[1];
    wire q_or  = state[0];

    // Next state computation combinationally
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    wire [2:0] next_state = {d_xor, d_and, d_or};

    always @(posedge clk) begin
        if (!init_done) begin
            // Initialize flip-flops to zero on first clock
            state <= 3'b000;
            init_done <= 1'b1;
        end else begin
            // Update state normally
            state <= next_state;
        end
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule