module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input signal

always @(posedge clk) begin
    anyedge <= in ^ prev_in;  // XOR operation to detect changes
    prev_in <= in;  // Update the previous state of the input signal
end

endmodule