module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] buffer = 8'b0;       // Circular buffer
reg [2:0] wr_ptr = 3'b111;     // Write pointer (MSB first)
wire [2:0] next_ptr;           // Next pointer value
wire [7:0] clk_gated;          // Bit-level clock gating

// Gray code pointer update (minimizes switching)
assign next_ptr = {wr_ptr[2], wr_ptr[1] ^ wr_ptr[2], wr_ptr[0] ^ wr_ptr[1]};

// Bit-level clock gating - only active bit receives clock
assign clk_gated = (8'b1 << wr_ptr) & {8{clk}};

// Dual-edge operation
always @(posedge clk) begin
    // Pointer update on positive edge
    wr_ptr <= next_ptr;
end

always @(negedge clk) begin
    // Buffer update on negative edge
    for (integer i = 0; i < 8; i = i + 1) begin
        if (clk_gated[i]) begin
            buffer[i] <= d;
        end
    end
end

// Output is direct buffer connection (no shifting needed)
assign q = buffer;

endmodule