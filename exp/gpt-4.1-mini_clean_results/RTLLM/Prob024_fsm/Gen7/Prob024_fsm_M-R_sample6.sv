module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding using 3 bits for 6 states
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state;

    // Next state logic as combinational function
    wire [2:0] next_state = (state == S0) ? ((IN) ? S1 : S0) :
                           (state == S1) ? ((IN) ? S1 : S2) :
                           (state == S2) ? ((IN) ? S1 : S3) :
                           (state == S3) ? ((IN) ? S4 : S0) :
                           (state == S4) ? ((IN) ? S5 : S2) :
                           (state == S5) ? ((IN) ? S1 : S2) : S0;

    // Output MATCH asserted when the FSM is in state S4 and input IN=1, i.e., on transition to S5
    assign MATCH = (state == S4) && IN;

    // Sequential block to update state with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

endmodule