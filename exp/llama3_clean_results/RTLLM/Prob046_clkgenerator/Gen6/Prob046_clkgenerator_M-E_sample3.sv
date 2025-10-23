module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] buff_chain; // A 4-stage buffer chain to mimic the ring oscillator

always @(buff_chain) begin // Run whenever the buffer chain changes
    buff_chain = {buff_chain[2:0], ~buff_chain[3]}; // Feedback the inverted last stage into the first stage
end

always @(posedge buff_chain[0]) begin // When the first buffer stage goes high
    clk = ~clk; // Toggle the clock output
end

initial begin // Initialize the buffer chain
    buff_chain = 4'b1000;
end

endmodule