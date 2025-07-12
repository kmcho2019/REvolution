module fsm(
    input   logic       IN,        // Input signal to the FSM
    input   logic       CLK,       // Clock signal used for synchronous operation
    input   logic       RST,       // Reset signal to initialize the FSM
    output  logic       MATCH      // Output signal indicating a match condition
);

// Define states for the FSM
enum logic [2:0] {
    IDLE = 3'b001,  // Initial state
    S1   = 3'b010,  // First '1' detected
    S2   = 3'b011,  // First '0' detected
    S3   = 3'b100,  // Second '0' detected
    S4   = 3'b101,  // Third '1' detected
    S5   = 3'b110   // Fourth '1' detected
} state, next_state;

// Sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S5)
            MATCH <= 1'b1;
        else
            MATCH <= 1'b0;
    end
end

// Combinational logic
always_comb begin
    next_state = state;  // Default is to stay in the same state
    case (state)
        IDLE: begin
            if (IN)
                next_state = S1;
        end
        S1: begin
            if (!IN)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (!IN)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if (IN)
                next_state = S4;
            else
                next_state = S2;
        end
        S4: begin
            if (IN)
                next_state = S5;
            else
                next_state = S1;
        end
        S5: begin
            next_state = IDLE;
        end
    endcase
end

endmodule