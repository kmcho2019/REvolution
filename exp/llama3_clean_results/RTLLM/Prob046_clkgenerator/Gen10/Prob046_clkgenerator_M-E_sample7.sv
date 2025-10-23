module clkgenerator #(
    parameter PERIOD = 10
)(
    input  wire clk_base,
    output reg  clk
);

reg [31:0] counter;
reg clk_int;

always @(posedge clk_base) begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2) - 1) begin
        counter <= 0;
        clk_int <= ~clk_int;
    end
end

always @(posedge clk_base) begin
    clk <= clk_int;
end

initial begin
    counter <= 0;
    clk_int <= 0;
    clk <= 0;
end

endmodule