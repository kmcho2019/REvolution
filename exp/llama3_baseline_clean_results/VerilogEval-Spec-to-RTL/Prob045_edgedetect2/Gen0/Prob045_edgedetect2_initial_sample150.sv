module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_next;

always @(posedge clk) begin
    prev_in <= in;
    anyedge <= anyedge_next;
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        anyedge_next[i] = in[i] ^ prev_in[i];
    end
end

endmodule