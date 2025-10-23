module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding using localparams
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Combinational next_state logic using conditional (ternary) operators
    assign next_state = (RST) ? S0 :
                        (state == S0) ? (IN ? S1 : S0) :
                        (state == S1) ? (IN ? S1 : S2) :
                        (state == S2) ? (IN ? S1 : S3) :
                        (state == S3) ? (IN ? S4 : S0) :
                        (state == S4) ? (IN ? S1 : S2) :
                        S0;

    // Sequential state register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: MATCH = 1 when in S4 and IN=1 (final bit of sequence)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule