module fsm(
    input IN,  // Input signal to the FSM
    input CLK, // Clock signal for synchronous operation
    input RST, // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition
);

reg [2:0] state; // State register to hold the current state

// Define states
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= IDLE; // Reset state to IDLE on reset
        MATCH <= 1'b0; // Reset MATCH to 0 on reset
    end else begin
        case(state)
            IDLE: begin
                if(IN == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 1'b0; // Reset MATCH to 0 in IDLE state
            end
            S1: begin
                if(IN == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE; // Incorrect sequence, reset to IDLE
                end
                MATCH <= 1'b0; // Reset MATCH to 0 in S1 state
            end
            S2: begin
                if(IN == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE; // Incorrect sequence, reset to IDLE
                end
                MATCH <= 1'b0; // Reset MATCH to 0 in S2 state
            end
            S3: begin
                if(IN == 1'b1) begin
                    state <= S4;
                end else begin
                    state <= IDLE; // Incorrect sequence, reset to IDLE
                end
                MATCH <= 1'b0; // Reset MATCH to 0 in S3 state
            end
            S4: begin
                if(IN == 1'b1) begin
                    state <= S5;
                end else begin
                    state <= IDLE; // Incorrect sequence, reset to IDLE
                end
                MATCH <= 1'b0; // Reset MATCH to 0 in S4 state
            end
            S5: begin
                MATCH <= 1'b1; // Set MATCH to 1 when reaching the final state
                if(IN == 1'b1) begin
                    state <= S5; // Stay in S5 if input continues to match
                end else begin
                    state <= IDLE; // Reset to IDLE if input does not match
                end
            end
            default: state <= IDLE; // Default case to ensure state machine integrity
        endcase
    end
end

endmodule