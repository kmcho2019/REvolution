module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] nextState;

// State encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

always @(*) begin
    case (state)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A; // default state
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // default output
    endcase
end

endmodule