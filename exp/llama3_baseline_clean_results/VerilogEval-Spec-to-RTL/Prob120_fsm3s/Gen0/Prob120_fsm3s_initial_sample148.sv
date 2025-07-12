module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] currentState;
reg [1:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case (currentState)
        A: begin
            if (!in) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (!in) begin
                nextState = C;
            end else begin
                nextState = B;
            end
        end
        C: begin
            if (!in) begin
                nextState = A;
            end else begin
                nextState = D;
            end
        end
        D: begin
            if (!in) begin
                nextState = C;
            end else begin
                nextState = B;
            end
        end
        default: nextState = A;
    endcase
end

always @(*) begin
    case (currentState)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule