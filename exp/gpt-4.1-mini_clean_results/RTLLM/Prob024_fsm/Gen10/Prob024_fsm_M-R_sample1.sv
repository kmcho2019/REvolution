module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary state encoding for states representing matched prefix lengths:
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic implemented as combinational continuous assignments
    wire is_in_1 = (IN == 1'b1);
    wire is_in_0 = (IN == 1'b0);

    assign next_state =
        (state == S0) ? (is_in_1 ? S1 : S0) :
        (state == S1) ? (is_in_0 ? S2 : S1) :
        (state == S2) ? (is_in_0 ? S3 : S1) :
        (state == S3) ? (is_in_1 ? S4 : S0) :
        (state == S4) ? (is_in_1 ? S1 : (is_in_0 ? S2 : S0)) :
        S0;

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is 1 when currently in S4 and input is '1'
    assign MATCH = (state == S4) & is_in_1;

endmodule