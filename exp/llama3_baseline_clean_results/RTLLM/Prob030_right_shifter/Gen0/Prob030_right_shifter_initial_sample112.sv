module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to hold the right-shifted value

initial
    q = 8'b0;  // Initialize the register to 0

always @ (posedge clk)  // Trigger on the rising edge of the clock
begin
    q <= {d, q[7:1]};  // Shift 'q' to the right and insert 'd' into the most significant position
end

endmodule