module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

initial begin
    count = 4;
end

always @(posedge clk) begin
    if (!a) begin
        count = count + 1;
        if (count == 7) begin
            count = 0;
        end
    end
end

assign q = count;

endmodule