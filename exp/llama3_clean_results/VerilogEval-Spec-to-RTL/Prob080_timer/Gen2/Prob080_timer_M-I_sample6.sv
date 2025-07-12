module TopModule (
    input  clk,
    input  load,
    input  [9:0] data,
    output tc
);

reg [9:0] count;

always @(posedge clk) begin
    if (load) begin
        count <= data;
    end else if (count != 0) begin
        count <= count - 1'b1; // Using 1'b1 for decrement to avoid any potential optimization issues
    end
end

assign tc = (count == 10'd0) ? 1'b1 : 1'b0; // Using 10'd0 for clarity and to match the data type of count

endmodule