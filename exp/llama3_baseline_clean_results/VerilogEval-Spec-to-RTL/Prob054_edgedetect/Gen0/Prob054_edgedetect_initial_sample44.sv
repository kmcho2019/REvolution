module TopModule(
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
        if (in[i] == 1'b1 && prev_in[i] == 1'b0) begin
            pedge[i] <= 1'b1;
        end else begin
            pedge[i] <= 1'b0;
        end
    end
end

endmodule