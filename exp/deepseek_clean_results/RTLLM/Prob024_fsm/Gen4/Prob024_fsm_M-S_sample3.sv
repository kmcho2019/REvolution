module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Binary encoded states
localparam [2:0] 
    IDLE  = 3'b000,
    S1    = 3'b001,
    S10   = 3'b010,
    S100  = 3'b011,
    S1001 = 3'b100;

reg [2:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                MATCH <= 1'b0;
                state <= IN ? S1 : IDLE;
            end
            S1: begin
                MATCH <= 1'b0;
                state <= IN ? S1 : S10;
            end
            S10: begin
                MATCH <= 1'b0;
                state <= IN ? IDLE : S100;
            end
            S100: begin
                MATCH <= 1'b0;
                state <= IN ? S1001 : IDLE;
            end
            S1001: begin
                MATCH <= IN;
                state <= IN ? S1 : IDLE;
            end
        endcase
    end
end

endmodule