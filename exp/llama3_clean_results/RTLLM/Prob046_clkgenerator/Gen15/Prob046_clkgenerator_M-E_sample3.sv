module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
reg clk_int = 0;

always #1 clk_int = ~clk_int; // Internal clock generator for demonstration

always @posedge(clk_int) begin
    if (counter == (PERIOD - 1)) begin
        counter <= 0;
        clk <= ~clk;
    end else begin
        counter <= counter + 1;
    end
end

initial begin
    clk = 0;
end

endmodule