module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset the counter to 0 when rst_n is low
    end else begin
        Q <= Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]}; // Simplified shift operation
    end
end

endmodule