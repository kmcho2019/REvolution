module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding for matched prefix length: 0 to 4
    reg [2:0] state, next_state;
    localparam S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;

    // Next state logic simplified with if-else
    always @(*) begin
        if (state == S0)       next_state = IN ? S1 : S0;
        else if (state == S1)  next_state = IN ? S1 : S2;
        else if (state == S2)  next_state = IN ? S1 : S3;
        else if (state == S3)  next_state = IN ? S4 : S0;
        else /* state == S4 */ next_state = IN ? S1 : S2;
    end

    // Sequential update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when state S4 and IN=1
    assign MATCH = (state == S4) && IN;

endmodule