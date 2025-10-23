module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // internal counter

always @(posedge clk) begin
    if (load) begin
        // load the counter with the data when load is 1
        count <= data;
    end else if (count > 0) begin
        // decrement the counter by 1 when load is 0
        count <= count - 1;
    end
end

assign tc = (count == 0); // assert tc when count is 0

endmodule