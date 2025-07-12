module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Calculate the feedback signal
        reg feedback;
        assign feedback = ~(out[3] ^ out[2]); // Invert the XOR of MSB and second MSB
        
        // Shift the bits and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule