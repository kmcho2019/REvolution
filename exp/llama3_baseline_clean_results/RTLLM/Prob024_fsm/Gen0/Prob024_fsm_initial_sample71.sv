module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal used for synchronous operation
    input RST,  // Reset signal to initialize the FSM
    output MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define the states of the FSM
reg [2:0] state;  // 3 bits to represent 6 states (S0 to S5)
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

// Initialize the output MATCH to 0
assign MATCH = (state == S5) && IN;

// Always block to handle the reset and state transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin  // Reset condition
        state <= S0;  // Reset the state to S0
    end else begin
        case (state)
            S0: begin
                if (IN) begin  // If input is 1, transition to S1
                    state <= S1;
                end else begin  // If input is 0, stay in S0
                    state <= S0;
                end
            end
            S1: begin
                if (!IN) begin  // If input is 0, transition to S2
                    state <= S2;
                end else begin  // If input is 1, stay in S1
                    state <= S1;
                end
            end
            S2: begin
                if (!IN) begin  // If input is 0, transition to S3
                    state <= S3;
                end else begin  // If input is 1, go back to S1
                    state <= S1;
                end
            end
            S3: begin
                if (IN) begin  // If input is 1, transition to S4
                    state <= S4;
                end else begin  // If input is 0, go back to S0
                    state <= S0;
                end
            end
            S4: begin
                if (IN) begin  // If input is 1, transition to S5
                    state <= S5;
                end else begin  // If input is 0, go back to S0
                    state <= S0;
                end
            end
            S5: begin
                if (IN) begin  // If input is 1, stay in S5 (match condition)
                    state <= S5;
                end else begin  // If input is 0, go back to S0
                    state <= S0;
                end
            end
            default: state <= S0;  // Default case to handle any unexpected state
        endcase
    end
end

endmodule