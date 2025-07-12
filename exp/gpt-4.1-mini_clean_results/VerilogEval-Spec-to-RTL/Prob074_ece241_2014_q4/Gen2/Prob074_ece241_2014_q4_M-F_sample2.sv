module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] state; // state[2]: ff_xor, state[1]: ff_and, state[0]: ff_or

    // Initialize flip-flops to zero at simulation start
    initial begin
        state = 3'b000;
    end

    // Combinational logic for next state bits (D inputs)
    // For each bit:
    // bit 2 (ff_xor): D = x XOR current ff_xor output (state[2])
    // bit 1 (ff_and): D = x AND complemented ff_and output (~state[1])
    // bit 0 (ff_or):  D = x OR complemented ff_or output (~state[0])
    wire d_xor = x ^ state[2];
    wire d_and = x & (~state[1]);
    wire d_or  = x | (~state[0]);

    wire [2:0] next_state = {d_xor, d_and, d_or};

    // Sequential update on posedge clk without reset port
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(state[2] | state[1] | state[0]);

endmodule