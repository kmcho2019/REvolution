module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [1:0] current_state; // 2-bit state register
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

// State transition logic with reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0; // Reset to initial state
        MATCH <= 1'b0;
    end else begin
        case (current_state)
            S0: begin
                if (IN) begin
                    current_state <= S1;
                end else begin
                    current_state <= S0;
                end
            end
            S1: begin
                if (~IN) begin
                    current_state <= S2;
                end else begin
                    current_state <= S1;
                end
            end
            S2: begin
                if (~IN) begin
                    current_state <= S3;
                end else begin
                    current_state <= S1;
                end
            end
            S3: begin
                if (IN) begin
                    current_state <= S0;
                    MATCH <= 1'b1;
                end else begin
                    current_state <= S0;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                current_state <= S0;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule