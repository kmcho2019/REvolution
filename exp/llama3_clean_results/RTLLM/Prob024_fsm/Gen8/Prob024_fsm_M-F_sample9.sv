module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states for the sequence detection
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state, nextState;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= nextState;
        case (state)
            IDLE: begin
                if (IN) nextState <= S1;
                else nextState <= IDLE;
            end
            S1: begin
                if (!IN) nextState <= S2;
                else nextState <= S1;
            end
            S2: begin
                if (!IN) nextState <= S3;
                else nextState <= S1;
            end
            S3: begin
                if (IN) nextState <= S4;
                else nextState <= IDLE;
            end
            S4: begin
                if (IN) begin
                    nextState <= S5;
                    MATCH <= 1;
                end else begin
                    nextState <= IDLE;
                    MATCH <= 0;
                end
            end
            S5: begin
                nextState <= IDLE;
                MATCH <= 0;
            end
            default: begin
                nextState <= IDLE;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule