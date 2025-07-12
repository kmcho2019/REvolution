module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// State encoding
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state, next_state;
reg prev_IN;

// Input change detection
always @(posedge CLK) begin
    if (RST) prev_IN <= 1'b0;
    else prev_IN <= IN;
end

// State transition
always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else if (IN != prev_IN) begin  // Only update on input change
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE:   next_state = IN ? S1 : IDLE;
        S1:     next_state = IN ? S1 : S10;
        S10:    next_state = IN ? S1 : S100;
        S100:   next_state = IN ? S1 : IDLE;
    endcase
end

// Pure Mealy output (combinational)
assign MATCH = (state == S100) && IN;

endmodule