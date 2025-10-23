module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Initialize the output to a default value
initial out = 4'b0000;

// Combinational logic to calculate the feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Sequential logic to update the state of the LFSR
always @ (posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero
        out <= 4'b0000;
    end else begin
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule