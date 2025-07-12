module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // States: S0 (3'b000), S1 (3'b001), S2 (3'b010), S3 (3'b011), S4 (3'b100), S5 (3'b101)
reg match;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state
        match <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // State S0
                if (IN == 1'b1) begin
                    state <= 3'b001; // Transition to S1 on '1'
                end else begin
                    state <= 3'b000; // Stay in S0 on '0'
                end
                match <= 1'b0;
            end
            3'b001: begin // State S1
                if (IN == 1'b0) begin
                    state <= 3'b010; // Transition to S2 on '0' after '1'
                end else begin
                    state <= 3'b001; // Stay in S1 on '1'
                end
                match <= 1'b0;
            end
            3'b010: begin // State S2
                if (IN == 1'b0) begin
                    state <= 3'b011; // Transition to S3 on '0' after '0'
                end else if (IN == 1'b1) begin
                    state <= 3'b001; // Transition back to S1 on '1'
                end else begin
                    state <= 3'b010; // Stay in S2
                end
                match <= 1'b0;
            end
            3'b011: begin // State S3
                if (IN == 1'b1) begin
                    state <= 3'b100; // Transition to S4 on '1' after '00'
                end else if (IN == 1'b0) begin
                    state <= 3'b010; // Transition back to S2 on '0'
                end else begin
                    state <= 3'b011; // Stay in S3
                end
                match <= 1'b0;
            end
            3'b100: begin // State S4
                if (IN == 1'b1) begin
                    state <= 3'b101; // Transition to S5 on '1' after '1'
                    match <= 1'b1; // Set MATCH to 1
                end else if (IN == 1'b0) begin
                    state <= 3'b011; // Transition back to S3 on '0'
                    match <= 1'b0;
                end else begin
                    state <= 3'b100; // Stay in S4
                    match <= 1'b0;
                end
            end
            3'b101: begin // State S5
                if (IN == 1'b1) begin
                    state <= 3'b101; // Stay in S5 on '1'
                    match <= 1'b0;
                end else if (IN == 1'b0) begin
                    state <= 3'b010; // Transition to S2 on '0'
                    match <= 1'b0;
                end else begin
                    state <= 3'b101; // Stay in S5
                    match <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000; // Default to S0
                match <= 1'b0;
            end
        endcase
    end
end

assign MATCH = match;

endmodule