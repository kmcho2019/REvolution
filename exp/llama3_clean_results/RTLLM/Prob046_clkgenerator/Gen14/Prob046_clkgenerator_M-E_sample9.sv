module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] accumulator = 0;
reg previous_state = 0;

always @(posedge accumulator) begin
    if (accumulator == (PERIOD / 2)) begin
        accumulator = 0;
        clk = ~clk;
    end
end

always #1 begin
    accumulator = accumulator + 1;
    if (accumulator == 0) begin
        previous_state = clk;
    end
end

initial begin
    accumulator = 0;
    clk = 0;
end

endmodule