module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Optimized state encoding with parameters
localparam [1:0]
    IDLE   = 2'b00,
    S1     = 2'b01,
    S10    = 2'b10,
    S100   = 2'b11;

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                state <= IN ? S1 : IDLE;
                MATCH <= 1'b0;
            end
            S1: begin
                state <= IN ? S1 : S10;
                MATCH <= 1'b0;
            end
            S10: begin
                state <= IN ? IDLE : S100;
                MATCH <= 1'b0;
            end
            S100: begin
                state <= IN ? S1 : IDLE;
                MATCH <= IN;  // Only assert when we get the final '1' of 10011
            end
            default: begin
                state <= IDLE;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule