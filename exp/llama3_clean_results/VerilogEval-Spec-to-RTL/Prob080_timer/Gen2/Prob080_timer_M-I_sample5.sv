module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
assign tc = ~|count; // Directly assert tc when all bits of count are 0

always @(posedge clk) begin
    if (load) begin
        count <= data;
    end else if (count > 10'd0) begin
        count <= count - 10'd1;
    end
end

endmodule