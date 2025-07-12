module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out;

always @ (posedge clk) begin
    if (rst) begin
        // Reset the register to zero
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        wire feedback;
        assign feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule