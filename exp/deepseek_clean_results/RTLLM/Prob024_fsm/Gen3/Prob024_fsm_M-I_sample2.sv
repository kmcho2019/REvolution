module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Explicit state encoding
reg [1:0] current_state, next_state;

localparam IDLE    = 2'b00;
localparam GOT1    = 2'b01;
localparam GOT10   = 2'b10;
localparam GOT100  = 2'b11;
localparam GOT1001 = 2'b00; // Will be changed to avoid sharing

// Clock gating signal
wire clk_enable = (current_state != IDLE) || IN;

// State transition and reset logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else if (clk_enable) begin
        current_state <= next_state;
        // Registered output - set when in GOT1001 state and IN=1
        MATCH <= (current_state == GOT1001) && IN;
    end else begin
        MATCH <= 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = IN ? GOT1 : IDLE;
        GOT1:    next_state = IN ? GOT1 : GOT10;
        GOT10:   next_state = IN ? GOT1 : GOT100;
        GOT100:  next_state = IN ? GOT1001 : IDLE;
        GOT1001: next_state = IN ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
end

endmodule