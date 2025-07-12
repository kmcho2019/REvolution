module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 4'b0;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (count == 4'b1111) begin
        count <= 4'b0;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule