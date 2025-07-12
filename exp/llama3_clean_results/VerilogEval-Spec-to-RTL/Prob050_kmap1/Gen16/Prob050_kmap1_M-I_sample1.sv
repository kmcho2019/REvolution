// Improved solution maintaining the same functionality but with a focus on optimization for PPA metrics.
module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

// Combinational logic description using an always block for flexibility.
always @(*) 
begin
    // Direct implementation of the simplified OR logic for efficiency.
    // This logic is already optimized for the given Karnaugh map.
    out = a | b | c;
end

endmodule