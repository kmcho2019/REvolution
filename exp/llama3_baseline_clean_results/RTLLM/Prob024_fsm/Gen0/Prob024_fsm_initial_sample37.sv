module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State register to hold the current state

// Define the states
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // After seeing the first '1'
localparam S2 = 3'b010; // After seeing '10'
localparam S3 = 3'b011; // After seeing '100'
localparam S4 = 3'b100; // After seeing '1001'
localparam S5 = 3'b101; // After seeing '10011'

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
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
                    state <= S2;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S2;
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