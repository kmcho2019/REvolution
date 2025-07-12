module TopModule(
    input [3:0] x,
    output f
);

always @(*)
begin
    case ({x[2], x[3]})
        2'b00: f = (~x[0] && ~x[1]) || (x[0] && ~x[1]);
        2'b01: f = 0;
        2'b11: f = (~x[0] && ~x[1]) || (~x[0] && x[1]) || (x[0] && x[1]);
        2'b10: f = (~x[0] && ~x[1]) || (x[0] && ~x[1]) || (x[0] && x[1]);
        default: f = 0;
    endcase
end

endmodule