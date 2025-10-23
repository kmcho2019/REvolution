module TopModule(
    output out
);
    wire unused_input;
    assign unused_input = 1'b1; // Assigning a value to avoid warnings about unused nets
    assign out = unused_input & 1'b0;
endmodule