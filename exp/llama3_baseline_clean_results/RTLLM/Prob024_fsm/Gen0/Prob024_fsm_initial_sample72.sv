module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Current state of the FSM

// Define the states
localparam S0 = 3'b000; // Initial state, waiting for the first '1'
localparam S1 = 3'b001; // Received the first '1', waiting for the first '0'
localparam S2 = 3'b010; // Received the first '0', waiting for the second '0'
localparam S3 = 3'b011; // Received the second '0', waiting for the first '1' in the second sequence
localparam S4 = 3'b100; // Received the first '1' in the second sequence, waiting for the second '1' in the second sequence

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset the FSM
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= S3;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S1; // Wrap around to S1 after a match
                    MATCH <= 1; // Set MATCH to '1' when the sequence is detected
                end else begin
                    state <= S3;
                    MATCH <= 0;
                end
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule