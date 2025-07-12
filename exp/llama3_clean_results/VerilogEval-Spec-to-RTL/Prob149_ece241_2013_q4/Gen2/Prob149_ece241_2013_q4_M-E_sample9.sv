module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

enum logic [2:0] {
    AboveS2,
    BetweenS2AndS1,
    BetweenS1AndS0,
    BelowS0
} currentState, nextState;

always @(*) begin
    case (1'b1)
        1'b1: begin
            if (s[2]) begin
                nextState = AboveS2;
            end else if (s[1]) begin
                nextState = BetweenS2AndS1;
            end else if (s[0]) begin
                nextState = BetweenS1AndS0;
            end else begin
                nextState = BelowS0;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= BelowS0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        currentState <= nextState;
        
        case (currentState)
            AboveS2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BetweenS2AndS1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (nextState > currentState);
            end
            BetweenS1AndS0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (nextState > currentState);
            end
            BelowS0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (nextState > currentState);
            end
        endcase
    end
end

endmodule