module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg [9:0] next_count;
reg tc_reg;
reg next_tc;

always @(*) begin
    next_count = count;
    next_tc = tc_reg;
    
    if (load) begin
        next_count = data;
        next_tc = 1'b0;
    end else if (count != 10'd0) begin
        next_count = count - 1;
        next_tc = 1'b0;
    end
    
    if (count == 10'd0) begin
        next_tc = 1'b1;
    end
end

always @(posedge clk) begin
    count <= next_count;
    tc_reg <= next_tc;
end

assign tc = tc_reg;

endmodule