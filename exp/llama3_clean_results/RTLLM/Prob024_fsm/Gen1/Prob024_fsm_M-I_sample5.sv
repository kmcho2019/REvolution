module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states using one-hot encoding
typedef enum logic [5:0] {
    IDLE = 6'b000001,
    S1   = 6'b000010,
    S2   = 6'b000100,
    S3   = 6'b001000,
    S4   = 6'b010000,
    S5   = 6'b100000
} state_t;

state_t current_state, next_state;

// Single always block for state transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        case (next_state)
            S5: MATCH <= 1'b1;
            default: MATCH <= 1'b0;
        endcase
    end
end

// Combinational logic for state transition
always @(*) begin
    case (current_state)
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
                next_state = IDLE;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = IDLE;
            end
        end
        S5: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule