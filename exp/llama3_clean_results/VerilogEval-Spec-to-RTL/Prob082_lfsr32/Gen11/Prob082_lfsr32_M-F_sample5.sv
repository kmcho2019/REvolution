module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define the tap mask as a parameter
parameter tap_mask = 32'h80000401;

// Calculate the next state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR to 32'h1
        q <= 32'h1;
    end else begin
        // Calculate the new MSB by XORing the tapped bits with the LSB
        reg new_msb;
        new_msb = 1'b0;
        if (tap_mask[31]) new_msb = new_msb ^ q[31];
        if (tap_mask[21]) new_msb = new_msb ^ q[21];
        if (tap_mask[1]) new_msb = new_msb ^ q[1];
        if (tap_mask[0]) new_msb = new_msb ^ q[0];
        new_msb = new_msb ^ q[0];
        
        // Shift the current state right and add the new MSB
        q <= {new_msb, q[31:1]};
    end
end

endmodule