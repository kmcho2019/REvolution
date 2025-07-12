module right_shifter #(
    parameter N = 8
)(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [N-1:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = {N{1'b0}};

// Always block to handle the right shift operation and update q
always @(posedge clk) begin
    q <= {d, q[N-1:1]};  // Directly update q by shifting its contents to the right and inserting d at the most significant bit
end

endmodule