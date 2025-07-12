module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define a temporary variable to store the new state of the LFSR
reg [31:0] next_state;

// Calculate the new MSB based on the taps and the current LSB
always @(*) begin
    // Calculate the XOR of the tapped bits with the LSB
    reg tap_xor = q[31] ^ q[21] ^ q[1] ^ q[0];
    
    // Calculate the new state of the LFSR
    next_state = {tap_xor, q[30:1]};
end

// Update the state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_state;
    end
end

endmodule