module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg [1:0] state;  // one-hot: state[0]=OFF, state[1]=ON

    // State transition logic
    wire [1:0] next_state;
    assign next_state[0] = (state[0] & ~j) |  // Stay OFF if j=0
                          (state[1] & k);    // Transition from ON if k=1

    assign next_state[1] = (state[0] & j) |   // Transition from OFF if j=1
                          (state[1] & ~k);    // Stay ON if k=0

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;  // Reset to OFF state
        end else begin
            state <= next_state;
        end
    end

    assign out = state[1];  // Output is ON state

endmodule