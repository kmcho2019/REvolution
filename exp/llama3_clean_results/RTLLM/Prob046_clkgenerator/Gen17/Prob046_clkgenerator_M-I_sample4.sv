module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial clk = 0;
reg [31:0] counter = 0;

always @(posedge clk) begin
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

always #1 begin
    if (counter == 0) begin
        clk <= 1'b0;
    end
end

endmodule