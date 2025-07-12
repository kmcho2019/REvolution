module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions with minimal encoding
localparam [1:0]
    IDLE  = 2'b00,
    GOT1  = 2'b01,
    GOT10 = 2'b10;

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        case (state)
            IDLE:  begin
                state <= IN ? GOT1 : IDLE;
                MATCH <= 1'b0;
            end
            GOT1: begin
                state <= IN ? GOT1 : GOT10;
                MATCH <= 1'b0;
            end
            GOT10: begin
                if (IN) begin
                    state <= GOT1;
                    MATCH <= 1'b1;  // Match when we get 10011
                end else begin
                    state <= GOT10;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule