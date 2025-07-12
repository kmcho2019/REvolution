module TopModule(
    input clk,
    input a,
    output reg q = 1'b1,
    output reg [1:0] count = 2'b00
);

always @(posedge clk) begin
    if (a) begin
        count <= count + 1'b1;
        if (count == 2'b11) begin
            q <= 1'b0;
        end
    end else begin
        count <= 2'b00;
    end
end

endmodule