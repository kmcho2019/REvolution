module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A:
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        B:
            next_state = r[0]? B : A;
        C:
            next_state = r[1]? C : A;
        D:
            next_state = r[2]? D : A;
        default:
            next_state = A;
    endcase
end

assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = (current_state == D);

endmodule