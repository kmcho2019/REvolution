module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] currentState, nextState;
reg [2:0] prev_s;
reg dfr_reg;

always @(*) begin
    case (currentState)
        2'b00: begin // State 0: Above s[2]
            if (s[2] && s[1] && s[0]) begin
                nextState = 2'b00;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end else if (s[1] && s[0]) begin
                nextState = 2'b01;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0]) begin
                nextState = 2'b10;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                nextState = 2'b11;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end
        end
        2'b01: begin // State 1: Between s[2] and s[1]
            if (s[2] && s[1] && s[0]) begin
                nextState = 2'b00;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end else if (s[1] && s[0]) begin
                nextState = 2'b01;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b0;
            end else if (s[0]) begin
                nextState = 2'b10;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                nextState = 2'b11;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end
        end
        2'b10: begin // State 2: Between s[1] and s[0]
            if (s[2] && s[1] && s[0]) begin
                nextState = 2'b00;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end else if (s[1] && s[0]) begin
                nextState = 2'b01;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b0;
            end else if (s[0]) begin
                nextState = 2'b10;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b0;
            end else begin
                nextState = 2'b11;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end
        end
        2'b11: begin // State 3: Below s[0]
            if (s[2] && s[1] && s[0]) begin
                nextState = 2'b00;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
                dfr = 1'b0;
            end else if (s[1] && s[0]) begin
                nextState = 2'b01;
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else if (s[0]) begin
                nextState = 2'b10;
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                nextState = 2'b11;
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b0;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= 2'b11;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        currentState <= nextState;
        dfr_reg <= dfr;
        prev_s <= s;
    end
end

assign fr2 = currentState == 2'b11;
assign fr1 = (currentState == 2'b10) || (currentState == 2'b11);
assign fr0 = (currentState == 2'b01) || (currentState == 2'b10) || (currentState == 2'b11);
assign dfr = dfr_reg;

endmodule