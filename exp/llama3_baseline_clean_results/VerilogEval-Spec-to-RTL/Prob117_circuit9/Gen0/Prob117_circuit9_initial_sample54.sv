module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (a == 1'b1) begin
        count <= 3'b100; // Reset count to 4
    end else begin
        count <= count + 1'b1;
    end
end

assign q = count;

endmodule