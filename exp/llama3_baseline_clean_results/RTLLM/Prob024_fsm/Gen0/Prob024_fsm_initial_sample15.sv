module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State register

// State definitions
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset state to S0
        MATCH <= 1'b0; // Reset MATCH to 0
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 1'b0;
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            S1: begin
                if (~IN) begin
                    state <= S2;
                    MATCH <= 1'b0;
                end else begin
                    state <= S1;
                    MATCH <= 1'b0;
                end
            end
            S2: begin
                if (~IN) begin
                    state <= S3;
                    MATCH <= 1'b0;
                end else begin
                    state <= S1;
                    MATCH <= 1'b0;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                    MATCH <= 1'b0;
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1'b1; // Set MATCH to 1 when sequence matches
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            S5: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1'b1; // Continuous detection
                end else begin
                    state <= S0;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= S0;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule