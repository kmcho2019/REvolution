module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg out0, out1, out2, out3;  // Individual bits of the LFSR output

// D flip-flops to store each bit of the LFSR
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out0 <= 1'b0;
        out1 <= 1'b0;
        out2 <= 1'b0;
        out3 <= 1'b0;
    end else begin
        // Calculate the feedback signal
        reg fb;
        fb = ~(out3 ^ out2);  // Invert the result of XORing the most significant and the second most significant bits
        
        // Shift the bits to the left and insert the feedback value at the least significant bit
        out0 <= out1;
        out1 <= out2;
        out2 <= out3;
        out3 <= fb;
    end
end

// Assign the individual bits to the output
assign out[0] = out0;
assign out[1] = out1;
assign out[2] = out2;
assign out[3] = out3;

endmodule