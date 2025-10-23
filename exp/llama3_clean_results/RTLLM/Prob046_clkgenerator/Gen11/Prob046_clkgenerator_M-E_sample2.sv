module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
reg [7:0] inverter_chain [9:0]; // Ring oscillator with 10 inverters

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2 - 1)) begin
        counter <= 0;
    end
end

always @(posedge clk) begin
    inverter_chain[0] <= ~inverter_chain[9]; // Ring oscillator
    for (int i = 1; i < 10; i++) begin
        inverter_chain[i] <= ~inverter_chain[i-1];
    end
end

assign clk = inverter_chain[5]; // Output clock signal

initial begin
    for (int i = 0; i < 10; i++) begin
        inverter_chain[i] = 0;
    end
    counter = 0;
end

endmodule