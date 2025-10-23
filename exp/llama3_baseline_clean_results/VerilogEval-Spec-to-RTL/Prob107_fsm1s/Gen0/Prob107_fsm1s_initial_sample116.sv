module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 2 states: 0 - B, 1 - A
parameter B = 0, A = 1;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= B;
    end else begin
        case(state)
            B: if(!in) state <= A; else state <= B;
            A: if(!in) state <= B; else state <= A;
            default: state <= B;
        endcase
    end
end

always @(*) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule