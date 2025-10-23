module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary)
    localparam [2:0]
        S0 = 3'd0,  // initial state, no bits matched
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4,  // matched '1001'
        S5 = 3'd5;  // matched '10011' (accepting state)

    reg [2:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S5 : S2;
            S5: next_state = (IN == 1'b0) ? S2 : S1;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output MATCH: asserted when current state is S4 and IN is 1 (last bit in sequence)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule