module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output
);

always @(posedge clk) begin
    q <= d; // On the positive edge of the clock, store 'd' in 'q'
end

endmodule