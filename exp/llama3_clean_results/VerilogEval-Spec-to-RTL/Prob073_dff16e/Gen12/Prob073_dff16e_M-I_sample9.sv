// Define the ByteRegister module with minor adjustments for potential synthesis optimization
module ByteRegister(
    input clk,
    input resetn,
    input ena,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (~resetn) begin
        // Initialize with reset value
        q <= 8'd0;
    end else if (ena) begin
        // Non-blocking assignment for sequential logic
        q <= d;
    end
end

endmodule

// Define the TopModule with the byte-enable controlled D flip-flops
module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Instantiate two ByteRegister modules for upper and lower bytes
ByteRegister lowerByteReg(
    .clk(clk),
    .resetn(resetn),
    .ena(byteena[0]),
    .d(d[7:0]),
    .q(q[7:0])
);

ByteRegister upperByteReg(
    .clk(clk),
    .resetn(resetn),
    .ena(byteena[1]),
    .d(d[15:8]),
    .q(q[15:8])
);

endmodule