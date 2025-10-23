module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
assign tc = (count == 10'd0);

always @(posedge clk) begin
    if (load) count <= data;
    else if (count > 0) count <= count - 1'd1;
end

endmodule