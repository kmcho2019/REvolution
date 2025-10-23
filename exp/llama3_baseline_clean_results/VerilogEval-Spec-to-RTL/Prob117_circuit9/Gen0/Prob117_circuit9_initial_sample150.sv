module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (~a) begin
        count <= (count + 1) % 8;
    end
end

assign q = count;

initial begin
    count = 4;
end

endmodule