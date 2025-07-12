module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]); // Invert the XOR of MSB and 2nd MSB

// Update the output on the rising edge of the clock
always @(posedge clk) begin
    if (rst) begin // If reset is high, initialize the register to zero
        out <= 4'b0000;
    end else begin // Otherwise, shift the bits left and insert the new feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule