module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // The assignment remains the same as it efficiently selects the 4-bit output based on the sel input.
    // This approach is chosen for its simplicity and area efficiency, making it a good starting point for further optimization.
    assign out = in[(sel * 4) +: 4];

endmodule