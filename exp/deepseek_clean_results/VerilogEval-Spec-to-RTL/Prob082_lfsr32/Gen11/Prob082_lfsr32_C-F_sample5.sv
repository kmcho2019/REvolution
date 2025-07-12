module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    q <= reset ? 32'h1 : {
        q[0],                 // New MSB from old LSB
        q[31:23],            // Untapped upper bits
        q[22] ^ q[0],         // Tap at bit 22
        q[21:3],             // Untapped middle bits
        q[2] ^ q[0],         // Tap at bit 2
        q[1] ^ q[0]          // Tap at bit 1
    };
end

endmodule