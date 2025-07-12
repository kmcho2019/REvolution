// Define a module for managing a byte of the 16-bit output
module ByteModule(
    input clk,
    input resetn,
    input byteena,
    input [7:0] d,
    output reg [7:0] q
);

// Use an always block to handle the positive edge of the clock
always @(posedge clk) begin
    // Prioritize the reset condition for synchronous reset
    if (~resetn) begin
        // Reset the output to zero
        q <= 8'd0;
    end else if (byteena) begin
        // If enabled, update the output with the input data
        q <= d;
    end
end

endmodule

// Define the top-level module
module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Instantiate two ByteModule instances for the upper and lower bytes
ByteModule upper_byte(
    .clk(clk),
    .resetn(resetn),
    .byteena(byteena[1]),
    .d(d[15:8]),
    .q(q[15:8])
);

ByteModule lower_byte(
    .clk(clk),
    .resetn(resetn),
    .byteena(byteena[0]),
    .d(d[7:0]),
    .q(q[7:0])
);

endmodule