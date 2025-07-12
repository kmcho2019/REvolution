module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg feedback_reg;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        feedback_reg <= 1'b0;
    end else begin
        feedback_reg <= q[0];
        q <= {feedback_reg, 
              q[31:23], 
              q[22] ^ feedback_reg, 
              q[21:3], 
              q[2] ^ feedback_reg, 
              q[1] ^ feedback_reg};
    end
end

endmodule