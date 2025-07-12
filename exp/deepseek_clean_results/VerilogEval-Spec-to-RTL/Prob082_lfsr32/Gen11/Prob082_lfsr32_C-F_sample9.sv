module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;
wire feedback = q[0];

assign next_q = reset ? 32'h1 : {
    feedback,                    // New MSB
    q[31:23],                   // Untapped upper bits
    q[22] ^ feedback,           // Tap at bit 22
    q[21:3],                    // Middle untapped bits
    q[2] ^ feedback,            // Tap at bit 2
    q[1] ^ feedback             // Tap at bit 1
};

always @(posedge clk) begin
    q <= next_q;
end

endmodule