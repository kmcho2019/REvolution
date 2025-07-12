module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk) begin
    if (!rst_n) Q <= 0;
    else Q <= {~Q[0], Q[63:1]};
end

endmodule