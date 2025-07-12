module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary state encoding for 5 states (3 bits sufficient)
    localparam [2:0]
        S0 = 3'd0,  // no bits matched
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001' (waiting for last '1')

    reg [2:0] state, next_state;

    // Next state combinational logic (pure combinational, using assigns)
    wire [2:0] ns_S0, ns_S1, ns_S2, ns_S3, ns_S4;

    // Define next state transitions per current state and input
    assign ns_S0 = (IN == 1'b1) ? S1 : S0;
    assign ns_S1 = (IN == 1'b0) ? S2 : S1;
    assign ns_S2 = (IN == 1'b0) ? S3 : S1;
    assign ns_S3 = (IN == 1'b1) ? S4 : S0;
    assign ns_S4 = (IN == 1'b1) ? S1 :
                   (IN == 1'b0) ? S2 : S0;

    // Combinational logic to select next_state based on current state
    assign next_state =
        (state == S0) ? ns_S0 :
        (state == S1) ? ns_S1 :
        (state == S2) ? ns_S2 :
        (state == S3) ? ns_S3 :
        (state == S4) ? ns_S4 :
        S0;

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: MATCH = 1 when in S4 and input IN=1 (last bit matches)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule