module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] next_q;  // Next state of the 'q' register

// State machine to handle the right shift operation
always @(posedge clk) begin
    q <= next_q;  // Update 'q' on each rising edge of the clock
end

// Continuous assignment to determine the next state of 'q'
assign next_q = {d, q[7:1]};  // Right shift 'q' by 1 bit and insert 'd' into the most significant position

endmodule