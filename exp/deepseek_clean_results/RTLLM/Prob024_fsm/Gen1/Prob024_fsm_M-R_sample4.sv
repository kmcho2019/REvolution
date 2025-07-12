module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);

    // State encoding
    parameter [2:0] 
        IDLE   = 3'b000,
        S1     = 3'b001,
        S10    = 3'b010,
        S100   = 3'b011,
        S1001  = 3'b100,
        S10011 = 3'b101;

    reg [2:0] state;
    wire [2:0] next_state;

    // State register
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    assign next_state = 
        (state == IDLE)   ? (IN ? S1 : IDLE) :
        (state == S1)     ? (IN ? S1 : S10) :
        (state == S10)    ? (IN ? S1 : S100) :
        (state == S100)   ? (IN ? S1001 : IDLE) :
        (state == S1001) ? (IN ? S10011 : S10) :
        (state == S10011)? (IN ? S1 : S10) : IDLE;

    // Output logic (Mealy style)
    assign MATCH = (state == S1001) && IN;

endmodule