module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;
reg [HALF_PERIOD-1:0] counter; // Counter variable
reg clk_reg; // Clock register

initial begin
    clk = 0; // Initialize clock signal to 0
    counter = 0; // Initialize counter to 0
    clk_reg = 0; // Initialize clock register to 0
end

always @(counter) begin
    if (counter == HALF_PERIOD - 1) begin
        clk_reg <= ~clk_reg; // Toggle clock register
        counter <= 0; // Reset counter
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

always @(posedge clk_reg or negedge clk_reg) begin
    clk <= clk_reg; // Update clock signal
end

endmodule