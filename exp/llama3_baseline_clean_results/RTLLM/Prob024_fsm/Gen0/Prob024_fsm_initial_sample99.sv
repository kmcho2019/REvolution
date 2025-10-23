module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

reg [3:0] state;
reg [3:0] next_state;
reg match;

always @(*) begin
    case (state)
        S0: begin
            if (IN == 1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (IN == 0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (IN == 0) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN == 1) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (IN == 1) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN == 1) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

always @(*) begin
    case (state)
        S5: match = (IN == 1)? 1'b1 : 1'b0;
        default: match = 1'b0;
    endcase
end

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end
    else begin
        state <= next_state;
        MATCH <= match;
    end
end

endmodule