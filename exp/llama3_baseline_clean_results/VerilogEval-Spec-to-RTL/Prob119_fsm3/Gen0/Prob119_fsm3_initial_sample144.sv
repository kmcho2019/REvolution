module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A;
    endcase
end

always @(*) begin
    case (state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule