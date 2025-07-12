module TopModule(
    input  clk,
    input  resetn,
    input  in,
    output out
);

reg [3:0] dffs;

always @(posedge clk) begin
    if (!resetn) begin
        dffs <= 4'd0;
    end else begin
        dffs <= {in, dffs[3:1]};
    end
end

assign out = dffs[0];

endmodule