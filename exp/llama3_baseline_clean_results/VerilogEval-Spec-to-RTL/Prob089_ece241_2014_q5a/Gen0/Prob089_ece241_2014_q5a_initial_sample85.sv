module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] data;
reg [4:0] count;
reg [31:0] result;
reg flag;
reg [31:0] temp;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        data <= 32'd0;
        count <= 5'd0;
        flag <= 1'b0;
        result <= 32'd0;
    end else begin
        if (flag == 1'b0) begin
            data <= {data[30:0], x};
            count <= count + 1;
            if (count == 5'd31) begin
                if (data[31] == 1'b1) begin
                    flag <= 1'b1;
                end
            end
        end else begin
            temp <= ~data + 1;
            result <= temp;
            z <= result[31 - count];
            count <= count - 1;
            if (count == 5'd0) begin
                flag <= 1'b0;
                data <= 32'd0;
                result <= 32'd0;
            end
        end
    end
end

endmodule