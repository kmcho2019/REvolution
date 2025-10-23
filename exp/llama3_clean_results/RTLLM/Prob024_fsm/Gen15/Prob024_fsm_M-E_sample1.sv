module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

enum logic [2:0] {
    S_IDLE = 3'b000, // Initial state
    S_FIRST_1 = 3'b001, // First '1' detected
    S_FIRST_0 = 3'b010, // First '0' after first '1'
    S_SECOND_0 = 3'b011, // Second '0' after first '1'
    S_SECOND_1 = 3'b100, // First '1' after two '0's
    S_MATCH = 3'b101 // Sequence matched
} state, next_state;

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S_IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state; // Default: stay in the same state
    MATCH = 1'b0; // Default: no match

    case (state)
        S_IDLE: begin
            if (IN) begin
                next_state = S_FIRST_1;
            end
        end
        S_FIRST_1: begin
            if (!IN) begin
                next_state = S_FIRST_0;
            end else begin
                next_state = S_IDLE; // Reset sequence detection if '1' is repeated
            end
        end
        S_FIRST_0: begin
            if (!IN) begin
                next_state = S_SECOND_0;
            end else begin
                next_state = S_FIRST_1; // Back to first '1' if '1' appears prematurely
            end
        end
        S_SECOND_0: begin
            if (IN) begin
                next_state = S_SECOND_1;
            end else begin
                next_state = S_IDLE; // Reset sequence detection if '0' is repeated
            end
        end
        S_SECOND_1: begin
            if (IN) begin
                next_state = S_MATCH;
                MATCH = 1'b1; // Sequence matched
            end else begin
                next_state = S_IDLE; // Reset sequence detection
            end
        end
        S_MATCH: begin
            next_state = S_IDLE; // Reset after match
        end
    endcase
end

endmodule