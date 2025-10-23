module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 0;
    else if (valid_count)
        out <= out + 1;
end

endmodule