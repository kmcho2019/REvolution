module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count = 4;

always @(posedge clk) begin
    if (~a) begin
        if (count == 7) begin
            count <= 0;
        end else if (count == 0) begin
            count <= 1;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;

endmodule