module TopModule(
    input  [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[0]})
        2'b01: f = (x[1] == 1 && x[2] == 1) || (x[1] == 1 && x[2] == 0);
        2'b11: f = (x[1] == 1 && x[2] == 1) || (x[1] == 1 && x[2] == 0);
        default: f = (x[3] == 1 && x[0] == 1 && x[1] == 1 && x[2] == 0) || (x[3] == 1 && x[0] == 1 && x[1] == 1 && x[2] == 1);
    endcase
end

endmodule