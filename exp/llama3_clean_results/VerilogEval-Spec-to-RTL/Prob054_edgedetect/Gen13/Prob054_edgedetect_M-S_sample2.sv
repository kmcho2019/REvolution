module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
    for (int i = 0; i < 8; i++) 
        pedge[i] <= in[i] && ~prev_in[i];
end

endmodule