module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Calculate the feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Update the LFSR state on the rising edge of the clock
always @(posedge clk) begin
    if (rst) begin  // If reset is high, initialize the register
        out <= 4'b0000;
    end else begin  // Otherwise, shift the bits left and insert the new feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule