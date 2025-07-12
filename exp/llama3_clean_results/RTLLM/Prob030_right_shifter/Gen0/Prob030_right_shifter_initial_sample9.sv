module right_shifter(
    input clk, // clock signal
    input d,   // input signal to be right-shifted
    output reg [7:0] q  // output signal representing the result of the right shift operation
);

initial q = 8'b0; // initialize q to 0

always @ (posedge clk) begin
    // right shift the current state by 1 bit
    q <= {d, q[7:1]}; 
end

endmodule