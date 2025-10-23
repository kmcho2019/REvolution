module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // Single feedback point for all XOR operations

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {feedback,            // Bit 32 (new MSB)
              q[31:23],             // Untapped bits 31-23
              q[22] ^ feedback,     // Tapped bit 22
              q[21:3],             // Untapped bits 21-3
              q[2] ^ feedback,     // Tapped bit 2
              q[1] ^ feedback};    // Tapped bit 1
    end
end

endmodule