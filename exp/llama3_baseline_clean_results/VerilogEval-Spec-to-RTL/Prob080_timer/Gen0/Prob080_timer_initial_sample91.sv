module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg tc_reg;

initial begin
    counter = 10'b0;
    tc_reg = 1'b0;
end

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        tc_reg <= 1'b0;
    end else if (counter > 10'b0) begin
        counter <= counter - 1;
        tc_reg <= 1'b0;
    end else begin
        tc_reg <= 1'b1;
    end
end

assign tc = tc_reg;

endmodule