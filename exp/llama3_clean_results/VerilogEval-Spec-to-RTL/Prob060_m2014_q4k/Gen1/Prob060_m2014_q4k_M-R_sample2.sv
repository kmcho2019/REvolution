module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg out1, out2, out3, out4;

always @(posedge clk) begin
    if (~resetn) begin
        out1 <= 1'b0;
        out2 <= 1'b0;
        out3 <= 1'b0;
        out4 <= 1'b0;
    end else begin
        out1 <= in;
        out2 <= out1;
        out3 <= out2;
        out4 <= out3;
    end
end

assign out = out4;

endmodule