module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) state <= A;
    else begin
        case (state)
            A:
                if (r[0]) state <= B;
                else if (r[1]) state <= C;
                else if (r[2]) state <= D;
            B:
                if (!r[0]) state <= A;
            C:
                if (!r[1]) state <= A;
            D:
                if (!r[2]) state <= A;
            default: state <= A;
        endcase
    end
end

assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = (state == D);

endmodule