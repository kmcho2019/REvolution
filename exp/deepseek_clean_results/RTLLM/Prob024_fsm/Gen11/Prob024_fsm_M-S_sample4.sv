module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// States
parameter IDLE  = 2'b00;
parameter GOT1  = 2'b01;
parameter GOT10 = 2'b10;

reg [1:0] state;
reg [3:0] history;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        history <= 4'b0;
        MATCH <= 1'b0;
    end else begin
        // Update history shift register
        history <= {history[2:0], IN};
        
        // State transition
        case (state)
            IDLE:  state <= IN ? GOT1 : IDLE;
            GOT1:  state <= IN ? GOT1 : GOT10;
            GOT10: state <= IN ? GOT1 : GOT10;
            default: state <= IDLE;
        endcase
        
        // Output is 1 when we have "1001" in history and current input is 1
        MATCH <= (history == 4'b1001) && IN;
    end
end

endmodule