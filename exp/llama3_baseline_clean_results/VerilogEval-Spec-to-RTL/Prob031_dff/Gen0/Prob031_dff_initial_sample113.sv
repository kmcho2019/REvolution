module TopModule(
    input clk,  // Clock input
    input d,   // Data input
    output reg q  // Output
);

always @(posedge clk) begin
    q <= d;  // On the positive edge of the clock, store the data
end

endmodule