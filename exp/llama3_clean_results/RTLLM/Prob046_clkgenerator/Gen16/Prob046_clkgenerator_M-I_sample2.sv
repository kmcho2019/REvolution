module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] counter; // Use a smaller counter size

initial begin
    clk = 0;
    counter = 0;
end

always @(posedge clk) begin
    if (counter >= (PERIOD / 2 - 1)) begin // Toggle clock when counter reaches half of the period
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

always @(counter) begin
    if (counter == (PERIOD / 2 - 1)) begin // Toggle clock signal when counter reaches half of the period
        clk <= ~clk;
    end
end

endmodule