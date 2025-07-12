module fsm(
    input IN,      // Input signal to the FSM
    input CLK,     // Clock signal used for synchronous operation
    input RST,     // Reset signal to initialize the FSM
    output MATCH   // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state;  // Current state of the FSM (3 bits to represent 6 states: S0 to S5)
reg match_reg;    // Register to store the MATCH signal

// Define the states
localparam S0 = 3'b000;  // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

// Initialize the state and MATCH signal
initial begin
    state = S0;
    match_reg = 1'b0;
end

// Update the state and MATCH signal on every clock cycle or reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;  // Reset the state to S0
        match_reg <= 1'b0;  // Reset the MATCH signal to 0
    end else begin
        case (state)
            S0: begin
                if (IN == 1'b1) begin
                    state <= S1;  // Transition to S1 on input 1
                end else begin
                    state <= S0;  // Stay in S0 on input 0
                end
            end
            S1: begin
                if (IN == 1'b0) begin
                    state <= S2;  // Transition to S2 on input 0
                end else begin
                    state <= S1;  // Stay in S1 on input 1
                end
            end
            S2: begin
                if (IN == 1'b0) begin
                    state <= S3;  // Transition to S3 on input 0
                end else begin
                    state <= S1;  // Go back to S1 on input 1
                end
            end
            S3: begin
                if (IN == 1'b1) begin
                    state <= S4;  // Transition to S4 on input 1
                end else begin
                    state <= S1;  // Go back to S1 on input 0
                end
            end
            S4: begin
                if (IN == 1'b1) begin
                    state <= S5;  // Transition to S5 on input 1
                    match_reg <= 1'b1;  // Set MATCH signal to 1
                end else begin
                    state <= S1;  // Go back to S1 on input 0
                end
            end
            S5: begin
                match_reg <= 1'b0;  // Reset MATCH signal to 0
                if (IN == 1'b1) begin
                    state <= S1;  // Go back to S1 on input 1
                end else if (IN == 1'b0) begin
                    state <= S1;  // Go back to S1 on input 0
                end
            end
            default: state <= S0;  // Default state is S0
        endcase
    end
end

// Assign the MATCH signal
assign MATCH = match_reg;

endmodule