module TopModule (
    input           clk,
    input   [7:0]   in,
    output  [7:0]   anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] !== in[i]) begin
            anyedge[i] <= 1'b1;
        end else begin
            anyedge[i] <= 1'b0;
        end
    end
end

endmodule