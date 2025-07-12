module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] counter = 0; // Counter to reach PERIOD / 2

always @(posedge clk or posedge counter) begin
    if (counter == (PERIOD / 2 - 1)) begin
        counter <= 0;
        clk <= ~clk; // Toggle the clock signal
    end else begin
        counter <= counter + 1;
    end
end

// Initial state of clk should be 0
initial begin
    clk = 0;
end

endmodule