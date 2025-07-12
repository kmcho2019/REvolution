module TopModule (
    input wire clk,
    input wire rst_n,
    input wire in,
    output reg out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 1'b0;
    else
        out <= in;
end

endmodule