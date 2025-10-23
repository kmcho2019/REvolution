module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

    // Initialize the register on reset
    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            // Calculate the feedback signal
            reg feedback;
            feedback = ~(out[3] ^ out[2]);
            
            // Shift the bits to the left and insert the feedback at the LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule