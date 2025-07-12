module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if(rst) begin
        // Reset the LFSR
        out <= 4'b0000;
    end else begin
        // Calculate the feedback
        reg [3:0] feedback;
        feedback[0] = ~(out[3] ^ out[2]);
        // Shift the bits
        out <= {out[2:0], feedback[0]};
    end
end

endmodule