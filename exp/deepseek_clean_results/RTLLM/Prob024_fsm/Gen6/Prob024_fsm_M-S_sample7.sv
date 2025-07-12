module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state;

always @(posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE:   state <= IN ? S1 : IDLE;
            S1:     state <= IN ? S1 : S10;
            S10:    state <= IN ? IDLE : S100;
            S100:   state <= IN ? S1 : IDLE;
        endcase
    end
end

always @(*) begin
    MATCH = (state == S100) && IN;
end

endmodule