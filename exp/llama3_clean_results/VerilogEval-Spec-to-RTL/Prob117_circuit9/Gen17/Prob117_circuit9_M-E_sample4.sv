module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] count;

initial begin
    count = 4;
    q = 4;
end

always @(posedge clk) begin
    if (a) begin
        count <= 4;
    end else begin
        if (count == 6) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
    q <= count;
end

endmodule