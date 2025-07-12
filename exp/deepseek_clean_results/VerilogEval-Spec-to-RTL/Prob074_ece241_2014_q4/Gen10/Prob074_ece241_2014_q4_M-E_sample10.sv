module TopModule (
    input clk,
    input x,
    output z
);

    reg [2:0] state;  // [2]:xor, [1]:and, [0]:or

    // Combinational logic for next state
    wire xor_next = x ^ state[2];
    wire and_next = x & ~state[1];
    wire or_next  = x | ~state[0];

    // Sequential update
    always @(posedge clk) begin
        state <= {xor_next, and_next, or_next};
    end

    // Output logic
    assign z = ~|state;

endmodule