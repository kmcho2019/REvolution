module TopModule(
    input       clk,  // clock signal
    input       w,    // input from previous stage
    input       R,    // value to load
    input       E,    // enable shift
    input       L,    // load signal
    output reg  Q     // output of the module
);

always @(posedge clk) begin
    if (L) begin
        // Load the value from input R
        Q <= R;
    end else if (E) begin
        // Shift in the value from the previous stage
        Q <= w;
    end
end

endmodule