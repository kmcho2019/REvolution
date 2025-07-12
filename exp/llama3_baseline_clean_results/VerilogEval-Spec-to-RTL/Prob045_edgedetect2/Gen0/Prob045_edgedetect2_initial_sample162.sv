module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        anyedge[i] = (in[i] !== prev_in[i]) ? 1'b1 : 1'b0;
    end
end

endmodule