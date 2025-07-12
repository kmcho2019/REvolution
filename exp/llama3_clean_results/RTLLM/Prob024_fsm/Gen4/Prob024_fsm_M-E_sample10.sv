module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Enum for the states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    S5
} state, next_state;

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= 1'b0;
        
        case (state)
            IDLE: begin
                if (IN) begin
                    next_state <= S1;
                end else begin
                    next_state <= IDLE;
                end
            end
            S1: begin
                if (~IN) begin
                    next_state <= S2;
                end else begin
                    next_state <= IDLE;
                end
            end
            S2: begin
                if (~IN) begin
                    next_state <= S3;
                end else begin
                    next_state <= IDLE;
                end
            end
            S3: begin
                if (IN) begin
                    next_state <= S4;
                end else begin
                    next_state <= IDLE;
                end
            end
            S4: begin
                if (IN) begin
                    next_state <= S5;
                    MATCH <= 1'b1;
                end else begin
                    next_state <= IDLE;
                end
            end
            S5: begin
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule