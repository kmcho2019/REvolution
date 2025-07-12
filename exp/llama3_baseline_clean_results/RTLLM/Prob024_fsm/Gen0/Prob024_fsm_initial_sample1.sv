module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // 6 states: 3 bits
reg [2:0] next_state;
reg match_reg;

always @(*) begin
    case (state)
        3'b000: begin // S0
            if (IN == 1'b1) begin
                next_state = 3'b001; // S1
            end else begin
                next_state = 3'b000; // S0
            end
        end
        3'b001: begin // S1
            if (IN == 1'b0) begin
                next_state = 3'b010; // S2
            end else begin
                next_state = 3'b001; // S1
            end
        end
        3'b010: begin // S2
            if (IN == 1'b0) begin
                next_state = 3'b011; // S3
            end else begin
                next_state = 3'b001; // S1
            end
        end
        3'b011: begin // S3
            if (IN == 1'b1) begin
                next_state = 3'b100; // S4
            end else begin
                next_state = 3'b001; // S1
            end
        end
        3'b100: begin // S4
            if (IN == 1'b1) begin
                next_state = 3'b101; // S5
            end else begin
                next_state = 3'b001; // S1
            end
        end
        3'b101: begin // S5
            if (IN == 1'b1) begin
                next_state = 3'b101; // S5
            end else begin
                next_state = 3'b001; // S1
            end
        end
        default: next_state = 3'b000; // S0
    endcase

    if (state == 3'b101 && IN == 1'b1) begin // S5
        match_reg = 1'b1;
    end else begin
        match_reg = 1'b0;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST == 1'b1) begin
        state <= 3'b000; // S0
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_reg;
    end
end

endmodule