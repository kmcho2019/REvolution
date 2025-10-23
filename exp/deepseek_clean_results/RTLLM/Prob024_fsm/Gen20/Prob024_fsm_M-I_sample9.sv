module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT1   = 2'b01;
localparam [1:0] GOT10  = 2'b10;
localparam [1:0] GOT100 = 2'b11;

reg [1:0] state, next_state;
reg match_comb;
reg clk_en;

// Clock gating logic
always @(*) begin
    clk_en = ~(state == IDLE && IN == 1'b0);
end

// State transition logic
always @(*) begin
    case (state)
        IDLE:   next_state = IN ? GOT1 : IDLE;
        GOT1:   next_state = IN ? GOT1 : GOT10;
        GOT10:  next_state = IN ? GOT1 : GOT100;
        GOT100: next_state = IN ? GOT1 : GOT10;
        default: next_state = IDLE;
    endcase
end

// State register with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else if (clk_en) begin
        state <= next_state;
    end
end

// Combinational output logic
always @(*) begin
    match_comb = (state == GOT100) && IN;
end

// Registered output for better timing
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= match_comb;
    end
end

endmodule