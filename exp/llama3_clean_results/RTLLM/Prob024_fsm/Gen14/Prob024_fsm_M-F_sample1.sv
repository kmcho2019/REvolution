module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Define states for the FSM
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    MATCH_STATE
} state, next_state;

// Reset logic
always @(posedge RST or posedge CLK) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (IN) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (~IN) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (~IN) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                if (IN) begin
                    state <= MATCH_STATE;
                end else begin
                    state <= IDLE;
                end
            end
            MATCH_STATE: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Combinational logic for MATCH signal
assign MATCH = (state == MATCH_STATE) ? 1'b1 : 1'b0;

endmodule