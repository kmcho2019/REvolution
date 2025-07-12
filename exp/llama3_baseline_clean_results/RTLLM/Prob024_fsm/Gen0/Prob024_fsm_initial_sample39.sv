module fsm(
    input IN,  // Input signal to the FSM
    input CLK, // Clock signal used for synchronous operation
    input RST, // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state;  // Current state of the FSM

// Define the states
localparam S0 = 3'b000;  // Initial state
localparam S1 = 3'b001;  // First '1' detected
localparam S2 = 3'b010;  // First '0' detected
localparam S3 = 3'b011;  // Second '0' detected
localparam S4 = 3'b100;  // First '1' after '00' detected

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;  // Reset to initial state
        MATCH <= 0;   // Reset MATCH signal
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;  // Transition to S1 if '1' detected
                end else begin
                    state <= S0;  // Stay in S0 if '0' detected
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;  // Transition to S2 if '0' detected
                end else begin
                    state <= S1;  // Stay in S1 if '1' detected (invalid sequence)
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;  // Transition to S3 if '0' detected
                end else begin
                    state <= S1;  // Reset to S1 if '1' detected (invalid sequence)
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;  // Transition to S4 if '1' detected
                end else begin
                    state <= S0;  // Reset to S0 if '0' detected (invalid sequence)
                end
            end
            S4: begin
                if (IN) begin
                    MATCH <= 1;  // Set MATCH to 1 if '1' detected (sequence matched)
                    state <= S0; // Reset to S0 for continuous detection
                end else begin
                    state <= S0;  // Reset to S0 if '0' detected (invalid sequence)
                    MATCH <= 0;   // Reset MATCH signal
                end
            end
            default: begin
                state <= S0;  // Default to initial state for any other condition
                MATCH <= 0;   // Reset MATCH signal
            end
        endcase
    end
end

endmodule