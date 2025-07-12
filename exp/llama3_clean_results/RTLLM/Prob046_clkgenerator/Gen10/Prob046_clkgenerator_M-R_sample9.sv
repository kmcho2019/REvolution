module clkgenerator #(
    parameter PERIOD = 10
)(
    input  wire clk_ref, // Reference clock
    output wire clk      // Generated clock signal
);

reg [31:0] counter = 0;
reg clk_reg = 0;

always @(posedge clk_ref) begin
    if (counter == (PERIOD / 2 - 1)) begin
        clk_reg <= ~clk_reg;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

assign clk = clk_reg;

endmodule