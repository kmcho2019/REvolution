module TopModule(
    input           clk,
    input   [7:0]   in,
    output  [7:0]   pedge
);

reg [7:0] previous_in;
reg [7:0] pedge;

always @(posedge clk) begin
    previous_in <= in;
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && previous_in[i] == 0) begin
            pedge[i] <= 1;
        end else begin
            pedge[i] <= 0;
        end
    end
end

endmodule