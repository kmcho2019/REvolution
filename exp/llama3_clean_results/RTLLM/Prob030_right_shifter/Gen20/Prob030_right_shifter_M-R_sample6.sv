module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'd0;

// Combinational logic to calculate the next state of q
wire [7:0] next_q;
assign next_q = {d, q[7:1]};

// Sequential logic to update q on the rising edge of the clock
always @(posedge clk) begin
    // Update q with the calculated next state
    q <= next_q;
end

endmodule