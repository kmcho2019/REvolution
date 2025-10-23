module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [2:0] ptr;  // 3-bit pointer (0-7)
reg current_bit;
reg initialized = 0;

// Combinatorial output generation
assign q = (initialized) ? (8'b1 << ptr) & {8{current_bit}} : 8'b0;

always @(posedge clk) begin
    if (!initialized) begin
        ptr <= 3'b111;  // Start at MSB position
        current_bit <= 1'b0;
        initialized <= 1'b1;
    end else begin
        // Update pointer (circular decrement)
        ptr <= (ptr == 3'b0) ? 3'b111 : ptr - 1;
        
        // Store new input bit
        current_bit <= d;
    end
end

endmodule