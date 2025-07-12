module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // S0: 3'b000, S1: 3'b001, S2: 3'b010, S3: 3'b011, S4: 3'b100, S5: 3'b101

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state to S0
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // S0
                if (IN) begin
                    state <= 3'b001; // Transition to S1 on '1'
                end else begin
                    state <= 3'b000; // Stay in S0 on '0'
                end
            end
            3'b001: begin // S1
                if (~IN) begin
                    state <= 3'b010; // Transition to S2 on '0'
                end else begin
                    state <= 3'b001; // Stay in S1 on '1'
                end
            end
            3'b010: begin // S2
                if (~IN) begin
                    state <= 3'b011; // Transition to S3 on '0'
                end else begin
                    state <= 3'b001; // Reset to S1 on '1'
                end
            end
            3'b011: begin // S3
                if (IN) begin
                    state <= 3'b100; // Transition to S4 on '1'
                end else begin
                    state <= 3'b001; // Reset to S1 on '0'
                end
            end
            3'b100: begin // S4
                if (IN) begin
                    state <= 3'b101; // Transition to S5 on '1'
                end else begin
                    state <= 3'b001; // Reset to S1 on '0'
                end
            end
            3'b101: begin // S5
                if (IN) begin
                    state <= 3'b101; // Stay in S5 on '1'
                    MATCH <= 1'b1;
                end else begin
                    state <= 3'b001; // Reset to S1 on '0'
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000; // Reset to S0 on unknown state
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule