module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

parameter S0 = 5'b00000;
parameter S1 = 5'b00001;
parameter S2 = 5'b00010;
parameter S3 = 5'b00100;
parameter S4 = 5'b01000;
parameter S5 = 5'b10000;

reg [4:0] state;
reg [4:0] next_state;

always @(*) begin
    case(state)
        S0: begin
            if (IN == 1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (IN == 0) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if (IN == 0) next_state = S3;
            else next_state = S0;
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

always @(posedge CLK or posedge RST) begin
    if (RST) state <= S0;
    else state <= next_state;
end

assign MATCH = (state == S5 && IN == 1)? 1'b1 : 1'b0;

endmodule