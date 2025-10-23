module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always_comb begin
    case(a)
        1'b0: q = 1'b0; // When 'a' is 0, select the second input (0)
        1'b1: q = b;    // When 'a' is 1, select the first input ('b')
    endcase
end

endmodule