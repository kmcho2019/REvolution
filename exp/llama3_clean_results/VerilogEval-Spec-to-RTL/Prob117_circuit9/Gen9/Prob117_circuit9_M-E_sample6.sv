module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*)
begin
    case (q)
        3'b000: next_q = a ? 4 : 1;
        3'b001: next_q = a ? 4 : 2;
        3'b010: next_q = a ? 4 : 3;
        3'b011: next_q = a ? 4 : 4;
        3'b100: next_q = a ? 4 : 5;
        3'b101: next_q = a ? 4 : 6;
        3'b110: next_q = a ? 4 : 0;
        3'b111: next_q = a ? 4 : 0;
        default: next_q = 4;
    endcase
end

always @(posedge clk)
    q <= next_q;

endmodule