module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q  // Output
);

always_ff @(posedge clk) begin
    q <= d; // On the positive edge of the clock, assign the value of d to q
end

endmodule