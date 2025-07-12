module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;  // internal counter
reg tc_reg;       // register for tc signal

assign tc = tc_reg;  // continuous assignment for tc output

always @(posedge clk) begin
    if (load) begin
        count <= data;  // load counter with data when load is high
        tc_reg <= 1'b0;  // reset tc signal when loading
    end else if (count != 0) begin
        count <= count - 1;  // decrement counter when load is low and count is not zero
    end
    if (count == 0) begin
        tc_reg <= 1'b1;  // assert tc signal when count reaches zero
    end
end

endmodule