module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= in[i] && !prev_in[i];
    end
end

endmodule