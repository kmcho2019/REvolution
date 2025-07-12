module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_reg;

always @(posedge clk) begin
    prev_in <= in;
    anyedge <= anyedge_reg;
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        if (in[i] != prev_in[i]) begin
            anyedge_reg[i] = 1'b1;
        end else begin
            anyedge_reg[i] = 1'b0;
        end
    end
end

endmodule