module right_shifter #(
    parameter N = 8
)(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [N-1:0] q  // Output signal representing the result of the right shift operation
);

// Combinational logic to perform the right shift operation
wire [N-1:0] next_q;
assign next_q = {d, q[N-1:1]};

// Initialize q to 0
initial q = {N{1'b0}};

// Always block to update q on the rising edge of the clock
always @(posedge clk) begin
    q <= next_q;  // Update q with the result of the right shift operation
end

endmodule