module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the states
localparam NUM_STATES = 6;
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100,
    MATCH_STATE = 3'b101
} curr_state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        curr_state <= IDLE;
        MATCH <= 0;
    end else begin
        curr_state <= next_state;
        case (curr_state)
            IDLE: begin
                if (IN) begin
                    next_state <= S1;
                    MATCH <= 0;
                end else begin
                    next_state <= IDLE;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (~IN) begin
                    next_state <= S2;
                    MATCH <= 0;
                end else begin
                    next_state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (~IN) begin
                    next_state <= S3;
                    MATCH <= 0;
                end else begin
                    next_state <= S1;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    next_state <= S4;
                    MATCH <= 0;
                end else begin
                    next_state <= IDLE;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    next_state <= MATCH_STATE;
                    MATCH <= 1;
                end else begin
                    next_state <= IDLE;
                    MATCH <= 0;
                end
            end
            MATCH_STATE: begin
                next_state <= IDLE;
                MATCH <= 0;
            end
            default: begin
                next_state <= IDLE;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule