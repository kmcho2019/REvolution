module fsm(
    input  wire        IN,     // Input signal to the FSM
    input  wire        CLK,    // Clock signal used for synchronous operation
    input  wire        RST,    // Reset signal to initialize the FSM
    output reg         MATCH   // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state;  // Current state of the FSM
localparam S0 = 3'b000;  // Initial state
localparam S1 = 3'b001;  // '1' detected
localparam S2 = 3'b010;  // '0' detected after '1'
localparam S3 = 3'b011;  // '0' detected after '0'
localparam S4 = 3'b100;  // '1' detected after '00'
localparam S5 = 3'b101;  // '1' detected after '1' (match detected)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;  // Reset to initial state
        MATCH <= 0;   // Reset MATCH signal
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;  // Move to S1 if '1' detected
                end else begin
                    state <= S0;  // Stay in S0 if '0' detected
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;  // Move to S2 if '0' detected
                end else begin
                    state <= S1;  // Stay in S1 if '1' detected
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;  // Move to S3 if '0' detected
                end else begin
                    state <= S1;  // Move to S1 if '1' detected
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;  // Move to S4 if '1' detected
                end else begin
                    state <= S0;  // Move to S0 if '0' detected
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;  // Move to S5 if '1' detected
                end else begin
                    state <= S0;  // Move to S0 if '0' detected
                end
            end
            S5: begin
                if (IN) begin
                    MATCH <= 1;  // Set MATCH signal if '1' detected
                    state <= S5;  // Stay in S5
                end else begin
                    MATCH <= 0;  // Reset MATCH signal
                    state <= S0;  // Move to S0
                end
            end
            default: begin
                state <= S0;  // Move to S0 if unknown state
            end
        endcase
    end
end

endmodule