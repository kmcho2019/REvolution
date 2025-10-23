module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

localparam A=2'd0, B=2'd1, C=2'd2, D=2'd3;
reg [1:0] state, next_state;

always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        A: begin
            if (r[0])      next_state = B;
            else if (r[1]) next_state = C;
            else if (r[2]) next_state = D;
            else           next_state = A;
        end
        B: next_state = r[0] ? B : A;
        C: next_state = r[1] ? C : A;
        D: next_state = r[2] ? D : A;
        default: next_state = A;
    endcase
end

always @(*) begin
    g = 3'b000;
    case (state)
        B: g = 3'b001;
        C: g = 3'b010;
        D: g = 3'b100;
    endcase
end

endmodule