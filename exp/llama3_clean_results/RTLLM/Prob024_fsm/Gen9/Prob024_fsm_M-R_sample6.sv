module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states for the sequence detection
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state, nextState;

// Combinational logic for next state calculation
always_comb begin
    case (state)
        IDLE: begin
            if (IN) nextState = S1;
            else nextState = IDLE;
        end
        S1: begin
            if (!IN) nextState = S2;
            else nextState = S1;
        end
        S2: begin
            if (!IN) nextState = S3;
            else nextState = S1;
        end
        S3: begin
            if (IN) nextState = S4;
            else nextState = IDLE;
        end
        S4: begin
            if (IN) nextState = S5;
            else nextState = IDLE;
        end
        S5: begin
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

// Sequential logic for state update and reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= nextState;
        case (state)
            S4: begin
                if (IN) MATCH <= 1;
                else MATCH <= 0;
            end
            S5: begin
                MATCH <= 1;
            end
            default: begin
                MATCH <= 0;
            end
        endcase
    end
end

endmodule