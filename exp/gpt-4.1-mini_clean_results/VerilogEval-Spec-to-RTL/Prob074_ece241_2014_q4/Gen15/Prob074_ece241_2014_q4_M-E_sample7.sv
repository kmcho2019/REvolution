module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] state; // state[2]: ff_xor, state[1]: ff_and, state[0]: ff_or

    // Initialize flip-flops to zero before simulation starts
    initial begin
        state = 3'b000;
    end

    wire d_xor = x ^ state[2];      // XOR gate: x and ff_xor output
    wire d_and = x & ~state[1];     // AND gate: x and complemented ff_and output
    wire d_or  = x | ~state[0];     // OR gate: x and complemented ff_or output

    always @(posedge clk) begin
        state[2] <= d_xor;
        state[1] <= d_and;
        state[0] <= d_or;
    end

    assign z = ~(state[2] | state[1] | state[0]); // NOR of all flip-flop outputs

endmodule