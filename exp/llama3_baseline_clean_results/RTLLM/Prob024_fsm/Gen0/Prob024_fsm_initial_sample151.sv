module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the states
typedef enum logic [2:0] {
    S0,
    S1,
    S2,
    S3,
    S4,
    S5
} state_t;

// Current state and next state
state_t current_state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (current_state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge CLK) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the MATCH output
always_comb begin
    case (current_state)
        S5: MATCH = (IN == 1)? 1 : 0;
        default: MATCH = 0;
    endcase
end

endmodule