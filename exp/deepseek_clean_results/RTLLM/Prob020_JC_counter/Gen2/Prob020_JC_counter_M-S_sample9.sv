module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {~Q[0], Q[63:1]};  // Right shift and set MSB to inverse of LSB
    end
end

endmodule