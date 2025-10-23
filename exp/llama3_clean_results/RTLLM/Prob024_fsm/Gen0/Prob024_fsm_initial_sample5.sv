module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // 3 bits can represent 8 states, but we'll use fewer
reg [2:0] nextState;

// Define states
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(*) begin
    case(state)
        S0: begin
            if(IN == 1'b1)
                nextState = S1;
            else
                nextState = S0;
        end
        S1: begin
            if(IN == 1'b0)
                nextState = S2;
            else if(IN == 1'b1)
                nextState = S1; // If another '1' comes, stay in S1
            else
                nextState = S0; // This line is technically redundant due to IN being only 1 bit
        end
        S2: begin
            if(IN == 1'b0)
                nextState = S3;
            else if(IN == 1'b1)
                nextState = S1; // Reset to S1 if '1' comes after '10'
            else
                nextState = S0;
        end
        S3: begin
            if(IN == 1'b1)
                nextState = S4;
            else if(IN == 1'b0)
                nextState = S3; // If another '0' comes, stay in S3
            else
                nextState = S0;
        end
        S4: begin
            if(IN == 1'b1)
                nextState = S5;
            else if(IN == 1'b0)
                nextState = S2; // Reset to S2 if '0' comes after '1001'
            else
                nextState = S0;
        end
        S5: begin
            if(IN == 1'b1)
                nextState = S5; // Stay in S5 as long as '1' comes after '10011'
            else
                nextState = S2; // If '0' comes after '10011', reset to S2
        end
        default: nextState = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= nextState;
        if(state == S5 && IN == 1'b1)
            MATCH <= 1'b1;
        else
            MATCH <= 1'b0;
    end
end

endmodule