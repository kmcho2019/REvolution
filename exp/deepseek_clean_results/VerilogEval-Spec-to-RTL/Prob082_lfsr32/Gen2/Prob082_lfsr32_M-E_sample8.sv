module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // Feedback term from LSB
wire [31:0] tap_mask = {32{feedback}} & 32'h80000003 | {32{feedback}} & 32'h00200000;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Parallel XOR all tap positions
        q <= (q ^ tap_mask) >> 1;
        // Insert feedback at MSB
        q[31] <= feedback;
    end
end

endmodule