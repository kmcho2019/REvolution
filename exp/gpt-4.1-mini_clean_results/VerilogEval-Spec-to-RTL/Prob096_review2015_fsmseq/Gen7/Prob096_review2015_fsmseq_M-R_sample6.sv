module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot state encoding
    localparam S0   = 4'b0001;
    localparam S1   = 4'b0010;
    localparam S11  = 4'b0100;
    localparam S110 = 4'b1000;

    reg [3:0] state;
    wire [3:0] next_state;

    // Next state logic using one-hot encoding with continuous assignments
    assign next_state[0] = (state[0] & ~data) | (state[3] & ~data);       // S0 next when data=0 from S0 or S110
    assign next_state[1] = (state[0] & data)  | (state[3] & data);        // S1 next when data=1 from S0 or S110
    assign next_state[2] = (state[1] & data)  | (state[2] & data);        // S11 next when data=1 from S1 or S11
    assign next_state[3] = (state[1] & ~data) | (state[2] & ~data);       // S110 next when data=0 from S1 or S11

    // Synchronous state update and start_shifting latch with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Detect sequence: transition into S110 with data=1 means sequence 1101 detected
            if (state[3] && data)
                start_shifting <= 1'b1;
        end
    end

endmodule