module TopModule (
    input clk,
    input x,
    output z
);

    reg [2:0] state = 3'b000;  // [2] = xor, [1] = and, [0] = or

    always @(posedge clk) begin
        state[2] <= x ^ state[2];       // XOR operation
        state[1] <= x & ~state[1];      // AND with complement
        state[0] <= x | ~state[0];      // OR with complement
    end

    assign z = ~(|state);  // NOR of all state bits

endmodule