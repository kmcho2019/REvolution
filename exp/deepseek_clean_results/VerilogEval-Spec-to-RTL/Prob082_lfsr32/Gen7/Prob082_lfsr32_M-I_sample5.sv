module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg feedback_reg;  // Registered feedback to break timing path
wire feedback = q[0];
wire feedback_enable = feedback;  // For clock gating optimization
wire [1:0] low_bits_xor = {q[2], q[1]} ^ {2{feedback}};  // Shared XOR for bits 2 and 1

always @(posedge clk) begin
    feedback_reg <= feedback;
    
    if (reset) begin
        q <= 32'h1;
    end
    else if (feedback_enable) begin
        // Full update when feedback is 1
        q <= {feedback_reg, 
              q[31:23], 
              q[22] ^ feedback_reg, 
              q[21:3], 
              low_bits_xor};
    end
    else begin
        // Shift-only when feedback is 0 (power saving)
        q <= {1'b0, q[31:1]};
    end
end

endmodule