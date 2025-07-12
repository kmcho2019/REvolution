module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

always_comb
begin
    case({a, b})
        2'b00: out = 1'b1;  // When both a and b are 0, out is 1
        2'b01, 2'b10, 2'b11: out = 1'b0;  // For any other combination, out is 0
        default: out = 1'bx;  // Default case for handling unknown inputs
    endcase
end

endmodule