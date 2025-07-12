module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    pedge <= 8'b0;
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1'b1 && prev_in[i] == 1'b0) begin
            pedge[i] <= 1'b1;
        end
    end
    prev_in <= in;
end

initial begin
    prev_in = 8'b0;
end

endmodule