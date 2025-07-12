module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM
reg match_reg; // Registered output of MATCH

always @(*) begin
    case(state)
        3'b000: begin // S0
            if (IN) begin
                next_state = 3'b001; // Transition to S1 on input '1'
                match_reg = 1'b0;
            end else begin
                next_state = 3'b000; // Stay in S0 on input '0'
                match_reg = 1'b0;
            end
        end
        3'b001: begin // S1
            if (~IN) begin
                next_state = 3'b010; // Transition to S2 on input '0'
                match_reg = 1'b0;
            end else begin
                next_state = 3'b001; // Stay in S1 on input '1'
                match_reg = 1'b0;
            end
        end
        3'b010: begin // S2
            if (~IN) begin
                next_state = 3'b011; // Transition to S3 on input '0'
                match_reg = 1'b0;
            end else begin
                next_state = 3'b001; // Transition back to S1 on input '1'
                match_reg = 1'b0;
            end
        end
        3'b011: begin // S3
            if (IN) begin
                next_state = 3'b100; // Transition to S4 on input '1'
                match_reg = 1'b0;
            end else begin
                next_state = 3'b000; // Transition back to S0 on input '0'
                match_reg = 1'b0;
            end
        end
        3'b100: begin // S4
            if (IN) begin
                next_state = 3'b101; // Transition to S5 on input '1'
                match_reg = 1'b1; // Output MATCH = 1
            end else begin
                next_state = 3'b000; // Transition back to S0 on input '0'
                match_reg = 1'b0;
            end
        end
        3'b101: begin // S5
            next_state = 3'b000; // Transition back to S0
            match_reg = 1'b0;
        end
        default: begin
            next_state = 3'b000; // Default state
            match_reg = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state to S0 on RST
        MATCH <= 1'b0; // Reset MATCH to 0
    end else begin
        state <= next_state; // Update state on positive edge of CLK
        MATCH <= match_reg; // Update MATCH on positive edge of CLK
    end
end

endmodule