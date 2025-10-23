module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state register to represent 8 states (IDLE to S5)
parameter IDLE = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // Reset FSM to IDLE state
        state <= IDLE;
        MATCH <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (IN == 1) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= IDLE;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (IN == 0) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= IDLE;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (IN == 0) begin
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    state <= IDLE;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN == 1) begin
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= IDLE;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN == 1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= IDLE;
                    MATCH <= 0;
                end
            end
            S5: begin
                state <= IDLE;
                MATCH <= 0;
            end
            default: begin
                state <= IDLE;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule