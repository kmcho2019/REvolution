module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

// Define states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    MATCH_STATE
} state, next_state;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (IN) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end
        S1: begin
            if (!IN) begin
                next_state <= S2;
            end else begin
                next_state <= IDLE;
            end
        end
        S2: begin
            if (!IN) begin
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
                next_state <= MATCH_STATE;
            end else begin
                next_state <= IDLE;
            end
        end
        MATCH_STATE: begin
            next_state <= IDLE;
        end
    endcase
end

// Output logic
assign MATCH = (state == MATCH_STATE) ? 1'b1 : 1'b0;

endmodule