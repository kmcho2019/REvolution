module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
localparam HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 0;
end

always @(posedge $global_clock) begin
    if (counter == HALF_PERIOD) begin
        clk <= ~clk;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

endmodule