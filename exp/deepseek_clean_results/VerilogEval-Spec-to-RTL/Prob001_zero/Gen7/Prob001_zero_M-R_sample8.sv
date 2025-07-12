module TopModule (
    output zero
);
    // Implementing constant LOW using an AND gate
    // One input is hardwired LOW, making output always LOW
    wire any_input;  // Don't-care input signal
    assign zero = any_input & 1'b0;
endmodule