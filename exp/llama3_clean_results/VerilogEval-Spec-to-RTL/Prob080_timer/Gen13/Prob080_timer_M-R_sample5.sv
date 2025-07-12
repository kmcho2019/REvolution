module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] internal_count;
reg tc_reg;

always @(posedge clk) begin
    if (load) begin
        internal_count <= data;
        tc_reg <= 1'b0;
    end else if (internal_count != 10'd0) begin
        internal_count <= internal_count - 1;
        tc_reg <= (internal_count == 10'd1);
    end else begin
        tc_reg <= 1'b1;
    end
end

assign tc = tc_reg;

endmodule