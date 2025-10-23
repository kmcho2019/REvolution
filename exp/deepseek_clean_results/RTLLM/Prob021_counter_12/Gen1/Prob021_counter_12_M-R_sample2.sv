module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire [3:0] next_out;

assign next_out = (!rst_n) ? 4'b0000 : 
                 (valid_count) ? ((out == 4'b1011) ? 4'b0000 : out + 1'b1) : 
                 out;

always @(posedge clk) begin
    out <= next_out;
end

endmodule