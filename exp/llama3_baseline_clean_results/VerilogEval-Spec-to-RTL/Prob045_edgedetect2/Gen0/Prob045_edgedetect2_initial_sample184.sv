module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in; // Register to store previous state of input signal

always @ (posedge clk) begin
    anyedge <= in ^ prev_in; // Detect edge using XOR gate
    prev_in <= in; // Update previous state register
end

endmodule