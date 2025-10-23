module fsm (
    input CLK,
    input RST,
    input IN,
    output MATCH
);

// States
parameter IDLE  = 2'b00;
parameter GOT1  = 2'b01;
parameter GOT10 = 2'b10;

reg [1:0] state;
reg [1:0] count; // To track the "11" after "100"

// State transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                state <= IN ? GOT1 : IDLE;
                count <= 2'b00;
            end
            GOT1: begin
                state <= IN ? GOT1 : GOT10;
                count <= 2'b00;
            end
            GOT10: begin
                if (IN) begin
                    if (count == 2'b01) begin
                        state <= GOT1; // Sequence complete, start over
                        count <= 2'b00;
                    end else begin
                        count <= count + 1;
                    end
                end else begin
                    state <= IDLE;
                    count <= 2'b00;
                end
            end
        endcase
    end
end

// Output logic - match when we've seen "10011"
assign MATCH = (state == GOT10) && (count == 2'b01) && IN && !RST;

endmodule