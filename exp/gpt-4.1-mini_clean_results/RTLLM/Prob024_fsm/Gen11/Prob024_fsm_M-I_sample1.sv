module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot state encoding for matched prefixes of "10011"
    // state0: no match
    // state1: matched '1'
    // state2: matched '10'
    // state3: matched '100'
    // state4: matched '1001'
    reg [4:0] state, next_state;

    // State encoding parameters for clarity
    localparam STATE0 = 5'b00001;
    localparam STATE1 = 5'b00010;
    localparam STATE2 = 5'b00100;
    localparam STATE3 = 5'b01000;
    localparam STATE4 = 5'b10000;

    // Next-state logic combinational
    always @(*) begin
        case (state)
            STATE0: next_state = (IN) ? STATE1 : STATE0;
            STATE1: next_state = (IN == 1'b0) ? STATE2 : STATE1;
            STATE2: next_state = (IN == 1'b0) ? STATE3 : STATE1;
            STATE3: next_state = (IN) ? STATE4 : STATE0;
            STATE4: next_state = (IN) ? STATE1 : STATE2;
            default: next_state = STATE0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= STATE0;
        else
            state <= next_state;
    end

    // Register MATCH output as Moore output: asserted when state4 is reached
    // This removes combinational glitches, improving power and signal integrity.
    always @(posedge CLK) begin
        if (RST)
            MATCH <= 1'b0;
        else
            // MATCH asserted when in STATE4 (means sequence fully matched)
            MATCH <= (state == STATE4);
    end

endmodule