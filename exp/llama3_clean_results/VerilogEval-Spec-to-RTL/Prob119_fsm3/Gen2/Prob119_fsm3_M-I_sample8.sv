module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

parameter A = 1'b0001;
parameter B = 1'b0010;
parameter C = 1'b0100;
parameter D = 1'b1000;

reg [3:0] current_state;

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
    out = (current_state == D);
end

endmodule