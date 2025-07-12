module TopModule (
    input clk,
    input x,
    output z
);

    reg [2:0] state = 3'b000;  // [xor_ff, and_ff, or_ff]

    always @(posedge clk) begin
        state[0] <= x ^ state[0];      // XOR with feedback
        state[1] <= x & ~state[1];     // AND with complemented feedback
        state[2] <= x | ~state[2];     // OR with complemented feedback
    end

    assign z = ~(|state);  // NOR of all flip-flop outputs

endmodule