module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg tc_reg;

always @(posedge clk) begin
    if (load) begin
        count <= data;
        tc_reg <= 1'b0;
    end else if (count > 0) begin
        count <= count - 1;
        tc_reg <= 1'b0;
    end else begin
        tc_reg <= 1'b1;
    end
end

assign tc = tc_reg;

endmodule