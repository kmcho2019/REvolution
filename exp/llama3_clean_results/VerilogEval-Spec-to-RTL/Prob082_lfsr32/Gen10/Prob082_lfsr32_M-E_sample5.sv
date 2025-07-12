module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define the tap mask
reg [31:0] tap_mask = 32'h80000401;

// Calculate the next state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR to 32'h1
        q <= 32'h1;
    end else begin
        // Calculate the new MSB by XORing the tapped bits with the LSB
        reg [31:0] tapped_bits = (q & tap_mask) ^ {31{q[0]}};
        reg [31:0] new_msb = tapped_bits[0];
        
        // Shift the current state right and add the new MSB
        q <= {new_msb, q[31:1]};
    end
end

endmodule