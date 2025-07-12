module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state_t;

// State registers
state_t current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        S0: begin
            MATCH = 1'b0;
            if (IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            MATCH = 1'b0;
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            MATCH = 1'b0;
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            MATCH = 1'b0;
            if (IN) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            MATCH = 1'b0;
            if (IN) next_state = S5;
            else next_state = S2;
        end
        S5: begin
            MATCH = 1'b1;
            if (IN) next_state = S1;
            else next_state = S2;
        end
        default: begin
            MATCH = 1'b0;
            next_state = S0;
        end
    endcase
end

endmodule