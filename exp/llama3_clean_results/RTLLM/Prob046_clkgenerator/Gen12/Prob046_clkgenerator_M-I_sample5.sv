module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

// Initialize clk
initial begin
    clk = 0;
end

// Toggle clk based on the counter and desired period
always @(posedge $global_clock) begin
    if (counter < (PERIOD / 2)) begin
        counter <= counter + 1;
    end else if (counter == (PERIOD / 2)) begin
        counter <= counter + 1;
        clk <= ~clk;
    end else if (counter < PERIOD) begin
        counter <= counter + 1;
    end else begin
        counter <= 0;
    end
end

endmodule