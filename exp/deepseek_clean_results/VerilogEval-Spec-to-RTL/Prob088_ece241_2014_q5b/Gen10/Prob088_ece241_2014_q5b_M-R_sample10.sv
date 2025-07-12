module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[1:0] where
    // 2'b01 = state A
    // 2'b10 = state B
    reg [1:0] state;

    // Next state logic (combinational)
    wire [1:0] next_state;
    assign next_state[0] = state[0] & ~x;  // Stay in A if x=0
    assign next_state[1] = (state[0] & x) | state[1];  // Enter B if x=1 in A, stay in B

    // Output logic (combinational)
    assign z = state[0] ? x : ~x;

    // State transition (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule