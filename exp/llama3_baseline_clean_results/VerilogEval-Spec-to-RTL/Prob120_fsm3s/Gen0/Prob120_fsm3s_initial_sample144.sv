module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state, next_state;

localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase

    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule