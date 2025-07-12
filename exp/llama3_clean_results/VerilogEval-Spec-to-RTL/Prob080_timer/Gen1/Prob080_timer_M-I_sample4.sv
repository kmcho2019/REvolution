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
        // Do not reset tc_reg here, let it stay 1 once count reaches 0
        // until load is asserted again.
    end
end

assign tc = tc_reg;

endmodule