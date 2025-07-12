module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

assign next_q = reset ? 32'h1 : {
    q[0],                     // New MSB from old LSB
    q[31:23],                 // Untapped upper bits (31-23)
    q[22] ^ q[0],             // Tap at bit 22
    q[21:3],                  // Untapped middle bits (21-3)
    q[2] ^ q[0],              // Tap at bit 2
    q[1] ^ q[0]               // Tap at bit 1
};

always @(posedge clk) begin
    q <= next_q;
end

endmodule