module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;
    pedge <= (prev_in & ~in) | (in & ~prev_in); // Simplify the logic for edge detection
end

endmodule