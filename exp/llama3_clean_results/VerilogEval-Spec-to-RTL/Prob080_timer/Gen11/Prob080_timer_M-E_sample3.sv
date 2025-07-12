module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg zero_flag;

assign tc = zero_flag;

always @(posedge clk)
begin
    if (load)
    begin
        count <= data;
        zero_flag <= 1'b0;
    end
    else if (!zero_flag)
    begin
        if (count == 10'd0)
        begin
            zero_flag <= 1'b1;
        end
        else
        begin
            count <= count - 1;
        end
    end
end

endmodule