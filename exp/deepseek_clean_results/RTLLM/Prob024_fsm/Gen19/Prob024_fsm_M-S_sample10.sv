module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// State definitions
localparam [1:0]
    IDLE   = 2'b00,
    GOT1   = 2'b01,
    GOT10  = 2'b10,
    GOT100 = 2'b11;

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        case (state)
            IDLE:   begin
                        state <= IN ? GOT1 : IDLE;
                        MATCH <= 1'b0;
                    end
            GOT1:   begin
                        state <= IN ? GOT1 : GOT10;
                        MATCH <= 1'b0;
                    end
            GOT10:  begin
                        state <= IN ? GOT1 : GOT100;
                        MATCH <= 1'b0;
                    end
            GOT100: begin
                        state <= IN ? GOT1 : GOT10;
                        MATCH <= IN;
                    end
        endcase
    end
end

endmodule