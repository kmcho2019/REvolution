module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // States: idle (3'b000), s1 (3'b001), s2 (3'b010), s3 (3'b011), s4 (3'b100), s5 (3'b101)
reg match_reg;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset to idle state
        match_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // idle state
                if (IN) begin
                    state <= 3'b001; // Move to s1 state
                end else begin
                    state <= 3'b000; // Stay in idle state
                end
                match_reg <= 1'b0;
            end
            3'b001: begin // s1 state
                if (~IN) begin
                    state <= 3'b010; // Move to s2 state
                end else begin
                    state <= 3'b001; // Stay in s1 state
                end
                match_reg <= 1'b0;
            end
            3'b010: begin // s2 state
                if (~IN) begin
                    state <= 3'b011; // Move to s3 state
                end else begin
                    state <= 3'b001; // Go back to s1 state
                end
                match_reg <= 1'b0;
            end
            3'b011: begin // s3 state
                if (IN) begin
                    state <= 3'b100; // Move to s4 state
                end else begin
                    state <= 3'b001; // Go back to s1 state
                end
                match_reg <= 1'b0;
            end
            3'b100: begin // s4 state
                if (IN) begin
                    state <= 3'b101; // Move to s5 state
                    match_reg <= 1'b1; // Set MATCH signal high
                end else begin
                    state <= 3'b001; // Go back to s1 state
                end
            end
            3'b101: begin // s5 state
                if (IN) begin
                    state <= 3'b101; // Stay in s5 state
                    match_reg <= 1'b1; // Set MATCH signal high
                end else begin
                    state <= 3'b001; // Go back to s1 state
                end
            end
            default: begin
                state <= 3'b000; // Reset to idle state
                match_reg <= 1'b0;
            end
        endcase
    end
end

assign MATCH = match_reg;

endmodule