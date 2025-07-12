module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y[1:0])
        2'b00: Y1 = w;
        2'b01: Y1 = ~w;
        2'b10: Y1 = 1'b1;
        2'b11: Y1 = ~w;
    endcase
end

endmodule