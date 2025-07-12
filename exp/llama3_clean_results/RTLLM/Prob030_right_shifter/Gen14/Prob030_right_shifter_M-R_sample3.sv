module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

always @(posedge clk) begin
    q_reg <= {d, q_reg[7:1]};
end

assign q = q_reg;

// Alternatively, to avoid using assign and directly drive the output from the always block
// module right_shifter(
//     input clk,  // Clock signal
//     input d,    // Input signal to be right-shifted
//     output reg [7:0] q  // Output signal representing the result of the right shift operation
// );

// always @(posedge clk) begin
//     q <= {d, q[7:1]};
// end

endmodule