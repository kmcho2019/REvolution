module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100,
    S5   = 3'b101
} state_t;

state_t current_state, next_state;

// Synchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S5) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
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