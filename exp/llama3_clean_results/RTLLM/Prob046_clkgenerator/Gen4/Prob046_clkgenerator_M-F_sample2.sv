module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk,
    input  reset
);

reg [7:0] counter; // Counter to track time
reg clk_int; // Internal clock signal

always @(posedge reset or counter) begin
    if (reset) begin
        counter <= 0; // Reset counter
        clk_int <= 1'b0; // Reset clock to 0
    end else if (counter == (PERIOD / 2)) begin
        counter <= 0; // Reset counter
        clk_int <= ~clk_int; // Toggle clock
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

assign clk = clk_int; // Assign internal clock to output

endmodule