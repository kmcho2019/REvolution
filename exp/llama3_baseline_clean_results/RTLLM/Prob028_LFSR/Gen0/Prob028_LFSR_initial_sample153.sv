module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero when reset is high
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits to the left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule