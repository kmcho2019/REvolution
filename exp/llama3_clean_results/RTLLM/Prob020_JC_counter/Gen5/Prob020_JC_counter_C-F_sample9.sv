module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0 when rst_n is low
        Q <= 64'd0;
    end else begin
        // Simplified conditional logic to update the counter
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule