module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state;

    // Combinational next state logic (pure combinational, expressed as assign)
    wire [2:0] next_state = (state == S0) ? ((IN == 1'b1) ? S1 : S0) :
                            (state == S1) ? ((IN == 1'b0) ? S2 : S1) :
                            (state == S2) ? ((IN == 1'b0) ? S3 : S1) :
                            (state == S3) ? ((IN == 1'b1) ? S4 : S0) :
                            (state == S4) ? ((IN == 1'b1) ? S1 : S2) :
                                            S0;

    // Combinational Mealy output logic
    wire match_comb = (state == S4) && (IN == 1'b1);

    // Sequential state register update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    assign MATCH = match_comb;

endmodule