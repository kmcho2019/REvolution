module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State encoding with clear names and compact representation
parameter [1:0]
    IDLE    = 2'b00,
    GOT1    = 2'b01,
    GOT10   = 2'b10,
    GOT100  = 2'b11;

reg [1:0] current_state, next_state;
reg match_comb;
reg clk_enable;

// Clock gating control
always @(*) begin
    clk_enable = (current_state != IDLE) || (next_state != IDLE);
end

// State update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Pipelined output register with clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else if (clk_enable) begin
        MATCH <= match_comb;
    end
end

// Combinational next state and match logic
always @(*) begin
    match_comb = 1'b0;
    case (current_state)
        IDLE: begin
            next_state = IN ? GOT1 : IDLE;
        end
        GOT1: begin
            next_state = IN ? GOT1 : GOT10;
        end
        GOT10: begin
            next_state = IN ? GOT1 : GOT100;
        end
        GOT100: begin
            next_state = IN ? GOT1 : GOT10;
            match_comb = IN;
        end
    endcase
end

endmodule