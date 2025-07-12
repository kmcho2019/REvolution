module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    Q <= !rst_n ? 64'b0 : {~Q[0], Q[63:1]};
end

endmodule