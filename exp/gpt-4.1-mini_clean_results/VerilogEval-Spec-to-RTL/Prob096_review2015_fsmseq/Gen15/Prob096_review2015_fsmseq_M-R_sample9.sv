module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot encoded states: only one bit high at a time
    localparam [4:0]
        S0 = 5'b00001, // no match
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" (final detected)

    reg [4:0] state;
    wire [4:0] next_state;

    // Next state logic using combinational assigns
    assign next_state[S0] = (state == S0) && (data == 1'b0) ||
                           (state == S1) && (data == 1'b0) ||
                           (state == S3) && (data == 1'b0) ||
                           (state == S4) ||
                           (state == S0 && data == 1'b0) ||
                           (state == S4);

    assign next_state[S1] = (state == S0) && (data == 1'b1);

    assign next_state[S2] = (state == S1) && (data == 1'b1) ||
                           (state == S2) && (data == 1'b1);

    assign next_state[S3] = (state == S2) && (data == 1'b0);

    assign next_state[S4] = (state == S3) && (data == 1'b1) ||
                           (state == S4);

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    assign start_shifting = (state == S4);

endmodule