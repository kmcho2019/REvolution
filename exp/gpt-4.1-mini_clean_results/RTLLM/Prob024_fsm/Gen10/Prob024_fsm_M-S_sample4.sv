module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    localparam S0 = 3'd0; // initial state
    localparam S1 = 3'd1; // detected '1'
    localparam S2 = 3'd2; // detected '10'
    localparam S3 = 3'd3; // detected '100'
    localparam S4 = 3'd4; // detected '1001'

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S1 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // State register update
    always @(posedge CLK) begin
        if (RST) 
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: MATCH = 1 when next input completes "10011" sequence
    always @(*) begin
        // MATCH is high only when current state is S4 and IN=1 (sequence complete)
        MATCH = (state == S4) && IN;
    end

endmodule