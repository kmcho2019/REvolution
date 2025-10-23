module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] count;
reg [31:0] half_period;

initial begin
    count = 0;
    half_period = PERIOD / 2;
    clk = 0;
end

always @(posedge count[0]) begin
    if (count == half_period) begin
        clk = ~clk; // Toggle the clock signal
        count = 0;
    end else begin
        count = count + 1;
    end
end

always #1 begin
    count[0] = ~count[0]; // Increment the counter
end

endmodule