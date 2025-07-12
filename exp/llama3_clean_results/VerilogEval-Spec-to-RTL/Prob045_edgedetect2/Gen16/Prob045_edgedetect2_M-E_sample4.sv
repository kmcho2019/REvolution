module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    prev_state <= in;
end

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        assign anyedge[i] = (in[i] ^ prev_state[i]);
    end
endgenerate

endmodule