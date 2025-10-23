module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @ (posedge clk)
begin
    // Shift the contents of q to the right by one bit
    q <= {d, q[7:1]};
end

// Alternatively, for better readability and synthesizability:
// always @ (posedge clk)
// begin
//     q[7] <= d;  // Assign the new input bit to the most significant position
//     for (int i = 6; i >= 0; i--) begin
//         q[i] <= q[i+1];  // Shift the bits to the right
//     end
// end

endmodule