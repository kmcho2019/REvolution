module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Define the lookup table based on the Karnaugh map
// For simplicity, we'll use a case statement to mimic the LUT behavior
always @(a, b, c) begin
    case ({a, b, c})
        3'b000: out = 0;
        3'b001: out = 1;
        3'b010: out = 1;
        3'b011: out = 1;
        3'b100: out = 1;
        3'b101: out = 1;
        3'b110: out = 1;
        3'b111: out = 1;
        default: out = 0; // Default case, though all combinations are covered
    endcase
end

endmodule