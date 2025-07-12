module TopModule(
    input       clk,
    input       resetn,
    input       in,
    output      out
);

reg [3:0] data;

always @(posedge clk) begin
    if (!resetn) begin
        data <= 4'd0;
    end else begin
        data <= {in, data[3:1]};
    end
end

assign out = data[0];

endmodule