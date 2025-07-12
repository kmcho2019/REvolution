module TopModule(
    input           clk,  // clock signal
    input   [7:0]   d,   // 8-bit input data
    output  [7:0]   q    // 8-bit output data
);

// Use 8 D flip-flops to store the input data
reg [7:0] q_reg; // Internal register to store the output

// Always block to handle the positive edge of the clock
always @(posedge clk) begin
    q_reg <= d; // On positive edge, update the internal register with input d
end

// Continuous assignment to output the stored value
assign q = q_reg; // Assign the internal register value to output q

endmodule