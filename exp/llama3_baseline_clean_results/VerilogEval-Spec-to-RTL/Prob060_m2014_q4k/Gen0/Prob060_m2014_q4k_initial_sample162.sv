module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] d;

assign out = d[3];

always @(posedge clk) begin
    if (!resetn) begin
        d <= 4'b0000;
    end else begin
        d <= {in, d[3:1]};
    end
end

endmodule