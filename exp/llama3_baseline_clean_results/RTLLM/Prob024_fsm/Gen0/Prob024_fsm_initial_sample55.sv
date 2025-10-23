module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Define the current state (3 bits for 6 states)

localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // Input '1' detected
localparam S2 = 3'b010; // Input '0' detected after '1'
localparam S3 = 3'b011; // Second '0' detected
localparam S4 = 3'b100; // Third '1' detected
localparam S5 = 3'b101; // Fourth '1' detected (match condition)

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset to S0
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
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S2;
                    MATCH <= 0;
                end
            end
        endcase
    end
end

endmodule