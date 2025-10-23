module TopModule(
    input clk,  // Clock input
    input d,    // Data input
    output reg q // Output (initialized as reg)
);

always @(posedge clk) begin
    q <= d; // Assign data to output q on the positive edge of the clock
end

endmodule