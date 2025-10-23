module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Define states
parameter IDLE   = 2'b00;
parameter S1     = 2'b01;
parameter S10    = 2'b10;
parameter S100   = 2'b11;
parameter S1001  = 3'b100;  // Only 3 states needed with clever encoding

reg [2:0] state;

// Combined state transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
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
                state <= IN ? S1 : S100;
                MATCH <= 1'b0;
            end
            S100: begin
                state <= IN ? S1001 : IDLE;
                MATCH <= 1'b0;
            end
            S1001: begin
                state <= IN ? S1 : S10;
                MATCH <= IN;  // Only set MATCH when IN=1 in S1001 state
            end
            default: begin
                state <= IDLE;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule