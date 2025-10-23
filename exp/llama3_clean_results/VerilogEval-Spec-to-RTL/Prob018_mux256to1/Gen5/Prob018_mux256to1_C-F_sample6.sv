module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output reg out // 1-bit output
);

    // Use the sel signal to index into the input vector and select the output
    // This is a 256-to-1 multiplexer, where sel=0 selects in[0], sel=1 selects in[1], etc.
    always @(*) begin
        out = in[sel]; // Assign the selected bit to the output
    end

endmodule