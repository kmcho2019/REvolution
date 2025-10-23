module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg tc_reg;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else if (counter > 0) begin
        counter <= counter - 1;
    end
    tc_reg <= (counter == 0)? 1'b1 : (load? 1'b0 : tc_reg);
end

assign tc = tc_reg;

endmodule