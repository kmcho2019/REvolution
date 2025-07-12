module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= (in)? B : A;
            B: current_state <= (in)? B : C;
            C: current_state <= (in)? D : A;
            D: current_state <= (in)? B : C;
            default: current_state <= A;
        endcase
    end
end

always @(*) begin
    case (current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule