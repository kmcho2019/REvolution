module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] output_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        output_reg <= 1;
    end else if (count == 9) begin
        count <= 0;
        output_reg <= 1;
    end else begin
        count <= count + 1;
        output_reg <= count + 1;
    end
end

assign q = output_reg;

endmodule