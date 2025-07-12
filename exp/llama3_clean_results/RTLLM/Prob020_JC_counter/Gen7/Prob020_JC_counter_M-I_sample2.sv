module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset the counter to 0 when rst_n is low
    end else begin
        // Directly append 1 if Q[0] is 0, otherwise append 0
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule