module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// Calculate the feedback signal: XOR of MSB and second MSB, then invert
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// LFSR logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule