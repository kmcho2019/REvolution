module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding: [0] = A, [1] = B
    reg [1:0] state;

    // Next state logic (one-hot)
    wire [1:0] next_state = areset ? 2'b01 : 
                          (state[0] & ~x) ? 2'b01 : 
                          (state[0] & x)  ? 2'b10 : 
                          state;

    // Output logic (z = x XOR state[1])
    assign z = x ^ state[1];

    // State transition with clock gating
    always @(posedge clk or posedge areset) begin
        state <= next_state;
    end

endmodule