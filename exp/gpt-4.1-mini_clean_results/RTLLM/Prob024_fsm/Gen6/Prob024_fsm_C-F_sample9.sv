module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (3-bit binary)
    localparam [2:0]
        S0 = 3'd0,  // no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4,  // matched '1001'
        S5 = 3'd5;  // matched '10011' (final)

    reg [2:0] state;

    // Combinational next state logic
    wire [2:0] next_state = (state == S0) ? (IN ? S1 : S0) :
                            (state == S1) ? (IN ? S1 : S2) :
                            (state == S2) ? (IN ? S1 : S3) :
                            (state == S3) ? (IN ? S4 : S0) :
                            (state == S4) ? (IN ? S5 : S2) :
                            (state == S5) ? (IN ? S1 : S2) :
                            S0;

    // Synchronous state update with reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when in S4 and input is 1 completing "10011"
    assign MATCH = (state == S4) && IN;

endmodule