module TopModule(
    input             clk,
    input       [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector

always @(posedge clk) begin
    prev_in <= in; // Update the previous state at each positive edge of the clock
    anyedge <= prev_in ^ in; // Compute the anyedge vector
end

endmodule