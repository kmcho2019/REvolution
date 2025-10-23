module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule