module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Compact state encoding
localparam [1:0] 
    IDLE = 2'b00,
    S1   = 2'b01,
    S10  = 2'b10,
    S100 = 2'b11;

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                MATCH <= 0;
                state <= IN ? S1 : IDLE;
            end
            S1: begin
                MATCH <= 0;
                state <= IN ? S1 : S10;
            end
            S10: begin
                MATCH <= 0;
                state <= IN ? IDLE : S100;
            end
            S100: begin
                MATCH <= IN;
                state <= IN ? S1 : IDLE;
            end
        endcase
    end
end

endmodule