module TopModule (
    output out
);
    // Implement as a 1-input LUT hardwired to output 0
    // The input to the LUT is a don't-care (could be tied to anything)
    wire unused_input;
    LUT #(
        .INIT(2'b00)  // Truth table: output 0 for both input cases
    ) constant_zero_lut (
        .I0(unused_input),
        .O(out)
    );
endmodule