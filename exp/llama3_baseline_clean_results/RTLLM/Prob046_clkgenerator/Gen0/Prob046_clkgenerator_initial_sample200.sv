module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

reg [31:0] count = 0;

always @(posedge clk or negedge clk) begin
    if (count == (PERIOD / 2)) begin
        clk <= ~clk;
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

initial begin
    clk = 0;
end

endmodule