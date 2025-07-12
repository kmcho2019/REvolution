module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary state encoding representing matched prefix lengths of "10011"
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001' (waiting for last '1')

    reg [2:0] state, next_state;

    // Input conditions for clarity
    wire is_1 = (IN == 1'b1);
    wire is_0 = (IN == 1'b0);

    // Next-state logic using combinational ternary operators for compactness and efficiency
    assign next_state =
        (state == S0) ? (is_1 ? S1 : S0) :
        (state == S1) ? (is_0 ? S2 : S1) :
        (state == S2) ? (is_0 ? S3 : S1) :
        (state == S3) ? (is_1 ? S4 : S0) :
        (state == S4) ? (is_1 ? S1 : (is_0 ? S2 : S0)) :
        S0;

    // Sequential state update with synchronous reset using non-blocking assignment
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted only when in S4 and current input is '1' (last bit of sequence)
    assign MATCH = (state == S4) & is_1;

endmodule