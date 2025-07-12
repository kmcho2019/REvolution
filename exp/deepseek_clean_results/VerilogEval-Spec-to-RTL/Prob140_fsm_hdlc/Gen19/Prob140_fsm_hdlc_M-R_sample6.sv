module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states (0-7 consecutive 1s)
    reg [7:0] state;

    // Next state logic
    wire [7:0] next_state;
    assign next_state = reset ? 8'b00000001 :  // Reset to state 0 (1 hot)
                      in ? {state[6:0], 1'b0} | (state[7] ? 8'b0 : {8{state != 0}} & {7'b0, state[7]}) :
                      8'b00000001;

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic (combinational)
    assign disc = (state[5] && !in);
    assign flag = (state[6] && !in);
    assign err = (state[6] && in) || state[7];

endmodule