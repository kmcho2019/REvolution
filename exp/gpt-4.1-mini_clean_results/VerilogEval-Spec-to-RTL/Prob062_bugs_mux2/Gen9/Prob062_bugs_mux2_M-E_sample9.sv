module TopModule (
    input  wire       sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire       out
);
    // Select entire 8-bit vector based on sel
    wire [7:0] selected_vector = sel ? b : a;

    // Output a single bit from the selected vector (e.g., bit 0)
    assign out = selected_vector[0];
endmodule