module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;
reg [PERIOD-1:0] ring;

initial begin
    counter = 0;
    clk = 0;
    ring = {PERIOD{1'b0}};
end

always @(posedge counter) begin
    if (counter == 1) begin
        ring[0] <= ~ring[0];
    end
end

always @(posedge ring[0]) begin
    for (int i = 1; i < PERIOD; i++) begin
        ring[i] <= ~ring[i-1];
    end
end

always @(posedge ring[PERIOD-1]) begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule