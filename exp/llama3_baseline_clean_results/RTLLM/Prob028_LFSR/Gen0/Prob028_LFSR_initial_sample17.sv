module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Always block to synchronize with the clock signal
always @ (posedge clk) begin
    if (rst) begin
        // Initialize the register to zero on active high reset
        out <= 4'd0;
    end else begin
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule