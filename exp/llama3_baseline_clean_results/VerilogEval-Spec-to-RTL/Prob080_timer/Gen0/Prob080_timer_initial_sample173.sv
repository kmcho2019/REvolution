module TopModule(
    input  clk,
    input  load,
    input  [9:0] data,
    output tc
);

reg [9:0] count;  // internal counter
assign tc = (count == 10'd0)? 1'b1 : 1'b0;  // terminal count signal

always @(posedge clk) begin
    if (load) begin
        count <= data;  // load the counter with the input data
    end else if (count > 10'd0) begin
        count <= count - 10'd1;  // decrement the counter
    end
end

endmodule