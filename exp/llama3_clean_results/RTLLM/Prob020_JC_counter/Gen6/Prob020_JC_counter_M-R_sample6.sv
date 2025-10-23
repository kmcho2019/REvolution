module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= '0; // Reset the counter to 0 when rst_n is low
    end else begin
        Q <= {~Q[0], Q[63:1]}; // Combine the conditional logic into a single line
    end
end

endmodule