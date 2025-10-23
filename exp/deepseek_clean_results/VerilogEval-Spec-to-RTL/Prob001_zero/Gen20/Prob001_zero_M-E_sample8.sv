module TopModule (
    output zero
);
    // Implement constant LOW using an AND gate with one input tied to 0
    wire unused_input;  // This will be optimized away during synthesis
    assign zero = 1'b0 & unused_input;
endmodule