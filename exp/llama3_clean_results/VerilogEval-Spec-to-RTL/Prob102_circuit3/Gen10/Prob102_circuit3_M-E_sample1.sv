module TopModule(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);

always_comb begin
    case ({a, b, c, d})
        4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b1000, 4'b1001, 4'b1010, 4'b1100: q = 1'b0;
        default: q = 1'b1;
    endcase
end

endmodule