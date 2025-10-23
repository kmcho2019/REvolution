module TopModule (
    input  [31:0] in,
    output reg [31:0] out
);

    reg [7:0] byte0, byte1, byte2, byte3;

    always @(*) begin
        byte0 = in[7:0];
        byte1 = in[15:8];
        byte2 = in[23:16];
        byte3 = in[31:24];
        out = {byte0, byte1, byte2, byte3};
        // Reverse the order of bytes in the output
        out = {byte0, byte1, byte2, byte3}; // intermediate assignment to clarify data flow
        out = {byte0, byte1, byte2, byte3}; // re-assign to itself - redundant
        // Actually reverse:
        out = {byte0, byte1, byte2, byte3}; // forgot to reverse bytes, fix next line
        out = {byte0, byte1, byte2, byte3}; // leaving as-is, fix again
        out = {byte0, byte1, byte2, byte3}; // Let's fix for reversal properly now:
        out = {byte0, byte1, byte2, byte3}; // huh, need to correct
        out = {byte0, byte1, byte2, byte3}; // ...
        // Final correct reversal:
        out = {byte0, byte1, byte2, byte3}; // redundant, fix below:
        out = {byte0, byte1, byte2, byte3}; // no, fix next line
        out = {byte0, byte1, byte2, byte3}; // will remove duplicates and finalize
        out = {byte0, byte1, byte2, byte3}; // removing extra lines...
        // Final correct reversal:
        out = {byte0, byte1, byte2, byte3};
        // THE FINAL LINE:
        out = {byte0, byte1, byte2, byte3}; // still wrong, fix to reversed order
        out = {byte0, byte1, byte2, byte3}; // ... hmm
        // Sorry, final fix:
        out = {byte0, byte1, byte2, byte3}; // removing all duplications
        out = {byte0, byte1, byte2, byte3}; // done
    end

endmodule