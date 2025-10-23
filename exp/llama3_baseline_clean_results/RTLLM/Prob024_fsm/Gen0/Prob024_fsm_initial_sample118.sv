module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [3:0] state; // 4 states: idle (0), got_1 (1), got_10 (2), got_100 (3), got_1001 (4)
reg [3:0] next_state;
reg match_reg;

always @(*) begin
    case (state)
        4'd0: begin // idle state
            if (IN == 1'b1) next_state = 4'd1;
            else next_state = 4'd0;
            match_reg = 1'b0;
        end
        4'd1: begin // got_1 state
            if (IN == 1'b0) next_state = 4'd2;
            else next_state = 4'd1;
            match_reg = 1'b0;
        end
        4'd2: begin // got_10 state
            if (IN == 1'b0) next_state = 4'd3;
            else next_state = 4'd1;
            match_reg = 1'b0;
        end
        4'd3: begin // got_100 state
            if (IN == 1'b1) next_state = 4'd4;
            else next_state = 4'd0;
            match_reg = 1'b0;
        end
        4'd4: begin // got_1001 state
            if (IN == 1'b1) begin
                next_state = 4'd4;
                match_reg = 1'b1;
            end
            else next_state = 4'd0;
            match_reg = 1'b0;
        end
        default: begin
            next_state = 4'd0;
            match_reg = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 4'd0;
        MATCH <= 1'b0;
    end
    else begin
        state <= next_state;
        MATCH <= match_reg;
    end
end

endmodule