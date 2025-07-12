module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

parameter A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;

reg [3:0] current_state;
reg [3:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (1'b1)
        current_state[0]: // State A
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        current_state[1]: // State B
            next_state = r[0]? B : A;
        current_state[2]: // State C
            next_state = r[1]? C : A;
        current_state[3]: // State D
            next_state = r[2]? D : A;
        default:
            next_state = A;
    endcase
end

assign g[0] = current_state[1]; // State B
assign g[1] = current_state[2]; // State C
assign g[2] = current_state[3]; // State D

endmodule