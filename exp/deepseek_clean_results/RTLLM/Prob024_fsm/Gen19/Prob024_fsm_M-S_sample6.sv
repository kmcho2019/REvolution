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

reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                MATCH <= 1'b0;
                state <= IN ? GOT1 : IDLE;
            end
            GOT1: begin
                MATCH <= 1'b0;
                state <= IN ? GOT1 : GOT10;
            end
            GOT10: begin
                MATCH <= 1'b0;
                state <= IN ? GOT1 : GOT100;
            end
            GOT100: begin
                MATCH <= IN;  // Output 1 when we get the final 1 in sequence
                state <= IN ? GOT1 : GOT10;
            end
        endcase
    end
end

endmodule