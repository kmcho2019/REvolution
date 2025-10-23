module TopModule(
    input  logic in, // Explicitly define in as a logic type for clarity
    output logic out // Explicitly define out as a logic type for clarity
);
    assign out = ~in; // The NOT operation remains the most straightforward implementation
endmodule