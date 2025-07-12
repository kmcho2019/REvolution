module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero
    end else begin
        // Calculate the feedback
        wire feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits and insert the new feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule