module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

reg [31:0] counter = 0;

always @(posedge clk or negedge clk) begin
    if(counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

initial begin
    clk = 0;
end

endmodule