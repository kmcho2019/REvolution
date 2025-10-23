module fsm(
    input  logic IN,  // Input signal to the FSM
    input  logic CLK, // Clock signal used for synchronous operation
    input  logic RST, // Reset signal to initialize the FSM
    output logic MATCH // Output signal indicating a match condition based on the FSM state
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100,
    S5   = 3'b101
} state, next_state;

// Sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    MATCH = 0;

    case (state)
        IDLE: begin
            if (IN) next_state = S1;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = IDLE;
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else next_state = IDLE;
        end
        S5: begin
            next_state = IDLE;
        end
    endcase
end

endmodule