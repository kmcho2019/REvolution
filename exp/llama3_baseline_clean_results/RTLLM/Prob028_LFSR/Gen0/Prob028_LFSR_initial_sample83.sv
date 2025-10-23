module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to zero
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal
        reg [3:0] feedback;
        feedback[0] = ~(out[3] ^ out[2]);
        // Shift the LFSR left and insert the new feedback value
        out <= {out[2:0], feedback[0]};
    end
end

endmodule