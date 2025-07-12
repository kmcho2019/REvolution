module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// Compact binary state encoding
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state, next_state;
reg IN_prev;
wire IN_changed = (IN != IN_prev);

// Clock gating control
wire fsm_active = (state != IDLE) || IN;
wire gated_clk = CLK & fsm_active;

// Input change detection
always @(posedge gated_clk or posedge RST) begin
    if (RST) begin
        IN_prev <= 1'b0;
    end else begin
        IN_prev <= IN;
    end
end

// State transition
always @(posedge gated_clk or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else if (IN_changed || (state != IDLE)) begin
        state <= next_state;
    end
end

// Next state logic (combinational)
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