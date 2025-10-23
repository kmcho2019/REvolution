module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Internal shift register with extended boundaries
reg [513:0] shift_reg;  // [0] = q[-1], [514:1] = q[0:511], [515] = q[512]

always @(posedge clk) begin
    if (load) begin
        q <= data;
        shift_reg <= {1'b0, data, 1'b0};  // Load data with boundary zeros
    end else begin
        // Process in segments with registered boundaries
        for (integer i = 0; i < 64; i = i + 1) begin
            // Process 8 bits at a time with registered boundaries
            shift_reg[i*8 + 1 +: 8] <= shift_reg[i*8 +: 8] ^ shift_reg[i*8 + 2 +: 8];
        end
        
        // Handle the boundaries
        shift_reg[0] <= 1'b0;      // Left boundary always 0
        shift_reg[513] <= 1'b0;    // Right boundary always 0
        
        // Update output
        q <= shift_reg[513:2];     // Extract the 512-bit state
    end
end

endmodule