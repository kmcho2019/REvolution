module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Refactored version using an always block for clarity and potential ease of modification if needed.
    always @(*)
    begin
        // Calculate the start index based on the sel input.
        int startIndex = sel * 4;
        
        // Assign the 4-bit output based on the calculated start index.
        out = in[startIndex +: 4];
    end

endmodule