module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'b0;

// Perform right shift operation on rising edge of clock
always @(posedge clk) begin
    // Directly manipulate bits to achieve right shift
    q[7] <= d;
    q[6] <= q[7];
    q[5] <= q[6];
    q[4] <= q[5];
    q[3] <= q[4];
    q[2] <= q[3];
    q[1] <= q[2];
    q[0] <= q[1];
end

endmodule