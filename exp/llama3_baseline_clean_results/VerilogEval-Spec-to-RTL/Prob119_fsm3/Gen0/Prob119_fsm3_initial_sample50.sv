module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] currentState;
reg [1:0] nextState;

always @(*) begin
    case(currentState)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        currentState <= A;
        out <= 0;
    end else begin
        currentState <= nextState;
        case(currentState)
            A: out <= 0;
            B: out <= 0;
            C: out <= 0;
            D: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule