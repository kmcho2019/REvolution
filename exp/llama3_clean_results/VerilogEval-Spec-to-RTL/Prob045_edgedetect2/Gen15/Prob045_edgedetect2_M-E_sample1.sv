module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] delayed_in;  // 8-bit shift register to delay the input signal

// Sequential logic to update the delayed input signal
always @(posedge clk) begin
    delayed_in <= in;  // Shift the input signal by one clock cycle
end

// Combinational logic to detect edges
always @(*) begin
    anyedge = in ^ delayed_in;  // Detect edges by comparing the current input with the delayed signal
end

endmodule