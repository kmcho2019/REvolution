module fsm(
    input  logic       IN,        // Input signal to the FSM
    input  logic       CLK,       // Clock signal used for synchronous operation
    input  logic       RST,       // Reset signal to initialize the FSM
    output logic       MATCH      // Output signal indicating a match condition based on the FSM state
);

// Define the states
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state, next_state;

// FSM state register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// FSM combinational logic
always_comb begin
    next_state = state;
    MATCH = 1'b0;

    case (state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end

        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end

        S2: begin
            if (~IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end

        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end

        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1'b1;
            end else begin
                next_state = S0;
            end
        end

        S5: begin
            next_state = S0;
        end

        default: begin
            next_state = S0;
        end
    endcase
end

endmodule