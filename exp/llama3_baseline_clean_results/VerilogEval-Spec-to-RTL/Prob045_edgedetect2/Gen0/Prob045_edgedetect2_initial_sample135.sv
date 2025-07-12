module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge;

always @(posedge clk) begin
    anyedge <= 8'b0;
    for (int i = 0; i < 8; i++) begin
        if (in[i] != prev_in[i]) begin
            anyedge[i] <= 1'b1;
        end
    end
    prev_in <= in;
end

endmodule