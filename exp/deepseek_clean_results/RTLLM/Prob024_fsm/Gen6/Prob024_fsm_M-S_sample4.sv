module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Binary encoded states
localparam [1:0] IDLE  = 2'b00,
                 S1    = 2'b01,
                 S10   = 2'b10,
                 S1001 = 2'b11;

reg [1:0] state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // Output is combination of current state and input
        MATCH <= (state == S1001) && IN;
    end
end

always @(*) begin
    case (state)
        IDLE:  next_state = IN ? S1 : IDLE;
        S1:    next_state = IN ? S1 : S10;
        S10:   next_state = IN ? S1001 : IDLE;
        S1001: next_state = IN ? S1 : IDLE;
    endcase
end

endmodule