module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // The LSB is the feedback term

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Optimized implementation with balanced XOR operations
        q <= {feedback, 
              q[31:22] ^ {10{feedback & q[21]}},  // Combine XOR for bits 31-22
              q[21] ^ feedback,
              q[20:2],
              q[1] ^ feedback,
              q[0] ^ feedback};
    end
end

endmodule