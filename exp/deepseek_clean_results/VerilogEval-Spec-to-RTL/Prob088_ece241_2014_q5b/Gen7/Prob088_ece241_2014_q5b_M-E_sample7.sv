module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Shift register implementation of one-hot states
    // [1:0] where bit 0 = state A, bit 1 = state B
    reg [1:0] state;

    // State transition - shift or hold based on input
    wire [1:0] next_state = x ? {state[0], 1'b0} : state;

    // Output is x XOR state[1] (Mealy machine)
    assign z = x ^ state[1];

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule