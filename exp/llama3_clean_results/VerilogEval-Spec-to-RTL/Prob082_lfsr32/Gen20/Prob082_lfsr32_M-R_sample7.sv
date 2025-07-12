module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define the tapped positions as constants
localparam TAP_31 = 1'b1;
localparam TAP_22 = 1'b1;
localparam TAP_2  = 1'b1;
localparam TAP_1  = 1'b1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to the specified initial value
        q <= 32'h1;
    end else begin
        // Calculate the feedback bit as the XOR of the taps and the LSB
        reg feedback = q[0] ^ (TAP_31 ? q[31] : 1'b0) ^ (TAP_22 ? q[21] : 1'b0) ^ (TAP_2 ? q[2] : 1'b0) ^ (TAP_1 ? q[1] : 1'b0);
        
        // Update each bit position based on the Galois LFSR rule
        q[31:1] <= q[30:0]; // Shift right for non-tapped positions
        if (TAP_31) q[31] <= feedback; // Update tapped position
        if (TAP_22) q[21] <= feedback; // Update tapped position
        if (TAP_2) q[2] <= feedback; // Update tapped position
        if (TAP_1) q[1] <= feedback; // Update tapped position
    end
end

endmodule