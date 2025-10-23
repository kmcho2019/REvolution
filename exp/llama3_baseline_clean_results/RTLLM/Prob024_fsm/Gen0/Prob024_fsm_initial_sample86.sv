module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the states for the FSM
enum logic [2:0] {
    IDLE  = 3'b000,  // Initial state
    S1    = 3'b001,  // First '1' detected
    S2    = 3'b010,  // First '0' detected after '1'
    S3    = 3'b011,  // Second '0' detected
    S4    = 3'b100,  // First '1' detected after two '0's
    S5    = 3'b101   // Second '1' detected, sequence complete
} state, next_state;

// Define the sequence
parameter SEQUENCE = 5'b10011;

always_comb begin
    case (state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S2;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        S5: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= next_state;
        case (state)
            S5: MATCH <= 1;
            default: MATCH <= 0;
        endcase
    end
end

endmodule