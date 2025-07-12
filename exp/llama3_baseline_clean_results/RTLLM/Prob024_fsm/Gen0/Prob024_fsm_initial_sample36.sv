module fsm(
    input IN,      // Input signal to the FSM
    input CLK,     // Clock signal used for synchronous operation
    input RST,     // Reset signal to initialize the FSM
    output MATCH   // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state;  // Current state of the FSM (3 bits to represent 6 states: S0 to S5)
reg [2:0] next_state;  // Next state of the FSM

// Define the states
localparam S0 = 3'b000;  // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// Assign the initial state
initial state = S0;

// FSM state transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;  // Reset to initial state on RST
        MATCH <= 1'b0;  // Reset MATCH to 0 on RST
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;  // Transition to S1 on IN = 1
                end else begin
                    state <= S0;  // Stay in S0 on IN = 0
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;  // Transition to S2 on IN = 0
                end else begin
                    state <= S1;  // Stay in S1 on IN = 1
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;  // Transition to S3 on IN = 0
                end else begin
                    state <= S1;  // Go back to S1 on IN = 1
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;  // Transition to S4 on IN = 1
                end else begin
                    state <= S1;  // Go back to S1 on IN = 0
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;  // Transition to S5 on IN = 1
                    MATCH <= 1'b1;  // Set MATCH to 1 on transition to S5
                end else begin
                    state <= S1;  // Go back to S1 on IN = 0
                end
            end
            S5: begin
                if (IN) begin
                    state <= S1;  // Go back to S1 on IN = 1
                end else begin
                    state <= S1;  // Go back to S1 on IN = 0
                end
            end
            default: state <= S0;  // Default to S0 on any other condition
        endcase
    end
end

// Continuous assignment for MATCH
assign MATCH = (state == S5) ? 1'b1 : 1'b0;

endmodule