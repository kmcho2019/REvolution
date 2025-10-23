module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always_comb begin
    case({a, b})
        2'b00: q = 1'b0;
        2'b01: q = 1'b0;
        2'b10: q = 1'b0;
        2'b11: q = 1'b1;
        default: q = 1'bx; // default case for handling unknown inputs
    endcase
end

endmodule