module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding
    reg [1:0] state;  // state[0] = OFF, state[1] = ON

    // State transition for OFF state (state[0])
    always @(posedge clk) begin
        if (reset)
            state[0] <= 1'b1;
        else if (state[0])
            state[0] <= ~j;
    end

    // State transition for ON state (state[1])
    always @(posedge clk) begin
        if (reset)
            state[1] <= 1'b0;
        else if (state[1])
            state[1] <= ~k;
        else
            state[1] <= state[0] & j;
    end

    // Output assignment - ON when state[1] is set
    assign out = state[1];

endmodule