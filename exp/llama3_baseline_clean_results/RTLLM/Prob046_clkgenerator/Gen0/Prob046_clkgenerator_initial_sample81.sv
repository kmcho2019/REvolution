module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] time_counter = 0;

initial begin
    clk = 0;
end

always @(posedge $global_clock) begin
    time_counter = time_counter + 1;
    if (time_counter == (PERIOD / 2)) begin
        clk = ~clk;
        time_counter = 0;
    end
end

endmodule