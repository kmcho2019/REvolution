module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire next_state;

    // Combinational next state logic: XOR of input and current state
    assign next_state = in ^ state;

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output is the current state
    assign out = state;

endmodule