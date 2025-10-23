module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

wire [7:0] next_q;  // Combinational logic to calculate the next value of q

assign next_q = {d, q[7:1]};  // Continuous assignment to calculate next_q

always @(posedge clk) begin
    q <= next_q;  // Update q on each rising edge of the clock
end

initial q = 8'd0;  // Initialize q to 0

endmodule