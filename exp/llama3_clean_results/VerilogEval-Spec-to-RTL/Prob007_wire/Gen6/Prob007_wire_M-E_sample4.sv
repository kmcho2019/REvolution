module TopModule(
    input  logic in,
    output logic out
);
    logic clk; // Internal clock signal
    assign clk = 1'b1; // Keep the clock signal always high

    // Use a transparent latch to propagate the input to the output
    always @(posedge clk) begin
        out <= in;
    end
endmodule