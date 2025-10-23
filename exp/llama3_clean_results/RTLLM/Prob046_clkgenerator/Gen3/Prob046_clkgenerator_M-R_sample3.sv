module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] counter; // Counter to track time
reg clk_int; // Internal clock signal

initial begin
    counter = 0; // Initialize counter
    clk_int = 1'b0; // Initialize clock to 0
end

always @(posedge counter) begin
    if (counter == (PERIOD / 2)) begin
        counter <= 0; // Reset counter
        clk_int <= ~clk_int; // Toggle clock
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

always #1 begin // Increment counter every time unit
    counter <= counter + 1;
end

assign clk = clk_int; // Assign internal clock to output

endmodule