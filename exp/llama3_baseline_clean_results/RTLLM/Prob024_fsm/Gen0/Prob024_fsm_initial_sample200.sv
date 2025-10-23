module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Current state of the FSM

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the FSM to the initial state
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    // Transition to state S1 on input 1
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    // Stay in state S0 on input 0
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (~IN) begin
                    // Transition to state S2 on input 0
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    // Reset to state S0 on input 1
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (~IN) begin
                    // Transition to state S3 on input 0
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    // Reset to state S0 on input 1
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    // Transition to state S4 on input 1
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    // Reset to state S0 on input 0
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    // Transition to state S5 on input 1
                    state <= S5;
                    MATCH <= 1; // Set MATCH to 1 on the last occurrence of IN=1
                end else begin
                    // Reset to state S0 on input 0
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                // Reset to state S0 after reaching the final state
                state <= S0;
                MATCH <= 0;
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule