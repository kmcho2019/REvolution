module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the states of the FSM
typedef enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state_t;

// Define the current state and next state signals
state_t current_state, next_state;

// Sequential logic for the FSM
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for the next state and output signals
always_comb begin
    case (current_state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
            MATCH = 0;
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
            MATCH = 0;
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
            MATCH = 0;
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
            MATCH = 0;
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S5: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 0;
        end
    endcase
end

endmodule