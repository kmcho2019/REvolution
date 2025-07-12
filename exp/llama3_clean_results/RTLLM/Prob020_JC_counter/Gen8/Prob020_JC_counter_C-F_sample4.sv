module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q <= 64'd0;
    end else begin
        // Normal operation: update Q based on its least significant bit
        Q <= Q[0]? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
    end
end

endmodule