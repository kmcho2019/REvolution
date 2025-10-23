module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Always block to handle clock and reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to zero when rst is high
        out <= 4'b0000;
    end else begin
        // Shift the bits left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule