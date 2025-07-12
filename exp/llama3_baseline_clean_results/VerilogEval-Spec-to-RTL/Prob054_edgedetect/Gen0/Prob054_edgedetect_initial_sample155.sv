module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge_reg;

always @(posedge clk) begin
    pedge_reg <= 8'b0;
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge_reg[i] <= 1'b1;
        end
    end
    prev_in <= in;
end

always @(*) begin
    pedge = pedge_reg;
end

endmodule