module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the states
enum logic [2:0] {
    Idle = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    Match = 3'b101
} state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= Idle;
        MATCH <= 0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                if (IN) begin
                    next_state <= S1;
                    MATCH <= 0;
                end else begin
                    next_state <= Idle;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (~IN) begin
                    next_state <= S2;
                    MATCH <= 0;
                end else begin
                    next_state <= Idle;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (~IN) begin
                    next_state <= S3;
                    MATCH <= 0;
                end else begin
                    next_state <= Idle;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    next_state <= S4;
                    MATCH <= 0;
                end else begin
                    next_state <= Idle;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    next_state <= Match;
                    MATCH <= 1;
                end else begin
                    next_state <= Idle;
                    MATCH <= 0;
                end
            end
            Match: begin
                if (IN) begin
                    next_state <= Match;
                    MATCH <= 1;
                end else begin
                    next_state <= Idle;
                    MATCH <= 0;
                end
            end
        endcase
    end
end

endmodule