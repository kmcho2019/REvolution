module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state variable

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // State S0
                if (IN) begin
                    state <= 3'b001; // Transition to S1
                end
            end
            3'b001: begin // State S1
                if (!IN) begin
                    state <= 3'b010; // Transition to S2
                end else begin
                    state <= 3'b001; // Stay in S1
                end
            end
            3'b010: begin // State S2
                if (!IN) begin
                    state <= 3'b011; // Transition to S3
                end else begin
                    state <= 3'b001; // Go back to S1
                end
            end
            3'b011: begin // State S3
                if (IN) begin
                    state <= 3'b100; // Transition to S4
                end else begin
                    state <= 3'b001; // Go back to S1
                end
            end
            3'b100: begin // State S4
                if (IN) begin
                    state <= 3'b100; // Stay in S4 and set MATCH to 1
                    MATCH <= 1'b1;
                end else begin
                    state <= 3'b001; // Go back to S1
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000; // Reset state
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule