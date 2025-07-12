module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

parameter A = 2'b00;
parameter B = 2'b01;

always @(*) begin
    case(state)
        A: next_state = (in == 1'b1) ? A : B;
        B: next_state = (in == 1'b1) ? B : A;
        default: next_state = B;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b1;
    endcase
end

endmodule