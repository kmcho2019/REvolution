module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always_comb begin
    case ({a, b})
        2'b00: q = 1'b0; // When a=0 and b=0, output q should be 0
        2'b01: q = 1'b0; // When a=0 and b=1, output q should be 0
        2'b10: q = 1'b0; // When a=1 and b=0, output q should be 0
        2'b11: q = 1'b1; // When a=1 and b=1, output q should be 1
        default: q = 1'b0; // Default case to handle any unexpected input combinations
    endcase
end

endmodule