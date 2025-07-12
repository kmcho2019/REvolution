module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge;

always @(posedge clk) begin
    prev_in <= in;
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] = prev_in[i] == 0 && in[i] == 1;
    end
end

endmodule