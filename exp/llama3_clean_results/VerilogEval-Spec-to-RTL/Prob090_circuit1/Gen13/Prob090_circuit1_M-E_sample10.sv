module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always_comb begin
    case ({a, b})
        2'b00: q = 0;
        2'b01: q = 0;
        2'b10: q = 0;
        2'b11: q = 1;
        default: q = 0; // Default case to handle any unexpected input combinations
    endcase
end

endmodule