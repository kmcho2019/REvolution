module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // 3 bits to represent 5 states (S0 to S4)
reg [2:0] next_state;
reg match_reg;

always @(*) begin
    case(state)
        3'b000: begin // S0
            if(IN) next_state = 3'b001;
            else next_state = 3'b000;
            match_reg = 1'b0;
        end
        3'b001: begin // S1
            if(!IN) next_state = 3'b010;
            else next_state = 3'b001;
            match_reg = 1'b0;
        end
        3'b010: begin // S2
            if(!IN) next_state = 3'b011;
            else next_state = 3'b001;
            match_reg = 1'b0;
        end
        3'b011: begin // S3
            if(IN) next_state = 3'b100;
            else next_state = 3'b000;
            match_reg = 1'b0;
        end
        3'b100: begin // S4
            if(IN) next_state = 3'b101;
            else next_state = 3'b000;
            match_reg = 1'b0;
        end
        3'b101: begin // S5
            if(IN) begin
                next_state = 3'b101;
                match_reg = 1'b1;
            end
            else next_state = 3'b000;
            match_reg = 1'b0;
        end
        default: next_state = 3'b000;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000;
        MATCH <= 1'b0;
    end
    else begin
        state <= next_state;
        MATCH <= match_reg;
    end
end

endmodule