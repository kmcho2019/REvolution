module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot encoding states
    localparam S0 = 5'b00001; // initial state
    localparam S1 = 5'b00010; // detected '1'
    localparam S2 = 5'b00100; // detected '10'
    localparam S3 = 5'b01000; // detected '100'
    localparam S4 = 5'b10000; // detected '1001'

    reg [4:0] state, next_state;

    // Next state logic combinational
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

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic combinational
    // MATCH is asserted when state is S4 and IN=1 (sequence "10011" detected)
    always @(*) begin
        MATCH = (state == S4) && IN;
    end

endmodule