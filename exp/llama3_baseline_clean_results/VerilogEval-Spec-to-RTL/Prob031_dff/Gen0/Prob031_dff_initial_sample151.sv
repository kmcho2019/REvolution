module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q // Output of the D flip-flop
);

always @(posedge clk) begin
    q <= d; // Update q on the positive edge of the clock
end

endmodule