module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg flag;

assign tc = flag && (count == 10'd0);

always @(posedge clk) begin
    if (load) begin
        count <= data;
        flag <= 1'b1;
    end else if (flag) begin
        count <= (count == 10'd0)? 10'd0 : count - 10'd1;
        if (count == 10'd0) begin
            flag <= 1'b0;
        end
    end
end

endmodule