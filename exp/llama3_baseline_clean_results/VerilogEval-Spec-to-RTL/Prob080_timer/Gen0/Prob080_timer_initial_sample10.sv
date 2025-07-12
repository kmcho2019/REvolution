module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // internal counter
assign tc = (count == 10'd0); // terminal count signal

always @(posedge clk) begin
    if (load) begin
        // load the counter with the data when load is 1
        count <= data;
    end else if (count > 0) begin
        // decrement the counter when load is 0 and count is not 0
        count <= count - 1;
    end
end

endmodule