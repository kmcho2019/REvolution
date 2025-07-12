module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

// Use a reg to store the shifted value
reg [7:0] q_reg;

// Always block to handle the clock edge and perform the shift
always @(posedge clk) begin
    // Perform the right shift operation and insert the new input bit
    q_reg <= {d, q_reg[7:1]};
end

// Continuous assignment to output the shifted value
assign q = q_reg;

endmodule