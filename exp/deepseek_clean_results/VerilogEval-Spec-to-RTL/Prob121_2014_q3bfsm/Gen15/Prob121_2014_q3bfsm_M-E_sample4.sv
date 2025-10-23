module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot encoding: [S4 S3 S2 S1 S0]
    reg [4:0] state;
    wire [4:0] next_state;

    // State definitions
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    // Parallel next state logic
    assign next_state[0] = (~x & state[0]) | (~x & state[3]);
    assign next_state[1] = (x & state[0]) | (~x & state[1]) | (x & state[2]) | (~x & state[3]);
    assign next_state[2] = (~x & state[2]) | (x & state[3]);
    assign next_state[3] = (~x & state[4]);
    assign next_state[4] = (x & state[1]) | (x & state[4]);

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output is active in states S3 and S4
    assign z = state[3] | state[4];

endmodule