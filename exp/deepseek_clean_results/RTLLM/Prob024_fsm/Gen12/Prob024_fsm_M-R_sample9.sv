module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Binary encoded states (3 bits for 5 distinct states)
parameter IDLE     = 3'b000;
parameter GOT1     = 3'b001;
parameter GOT10    = 3'b010;
parameter GOT100   = 3'b011;
parameter GOT1001  = 3'b100;

reg [2:0] current_state;

// Combined state transition and output logic
always @(posedge CLK) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        MATCH <= 1'b0;  // Default output
        
        case (current_state)
            IDLE: begin
                if (IN) current_state <= GOT1;
            end
            GOT1: begin
                if (!IN) current_state <= GOT10;
                else current_state <= GOT1;
            end
            GOT10: begin
                if (!IN) current_state <= GOT100;
                else current_state <= GOT1;
            end
            GOT100: begin
                if (IN) current_state <= GOT1001;
                else current_state <= IDLE;
            end
            GOT1001: begin
                if (IN) begin
                    MATCH <= 1'b1;
                    current_state <= GOT1;
                end else begin
                    current_state <= GOT10;
                end
            end
        endcase
    end
end

endmodule