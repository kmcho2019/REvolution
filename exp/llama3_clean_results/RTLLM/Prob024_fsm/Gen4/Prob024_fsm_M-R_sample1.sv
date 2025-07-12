module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

typedef enum logic [2:0] {
    IDLE = 3'b000,
    START = 3'b001,
    ZERO1 = 3'b010,
    ZERO2 = 3'b011,
    ONE1 = 3'b100,
    ONE2 = 3'b101
} state_t;

state_t current_state, next_state;

assign MATCH = (current_state == ONE2);

always_comb begin
    case (current_state)
        IDLE: begin
            if (IN) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            if (!IN) begin
                next_state = ZERO1;
            end else begin
                next_state = IDLE;
            end
        end
        ZERO1: begin
            if (!IN) begin
                next_state = ZERO2;
            end else begin
                next_state = IDLE;
            end
        end
        ZERO2: begin
            if (IN) begin
                next_state = ONE1;
            end else begin
                next_state = IDLE;
            end
        end
        ONE1: begin
            if (IN) begin
                next_state = ONE2;
            end else begin
                next_state = IDLE;
            end
        end
        ONE2: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule