module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store the previous state of the input vector

always @ (posedge clk) begin
    prev_in <= in; // update the previous state register on the positive edge of the clock
end

always @ (*) begin
    anyedge <= in ^ prev_in; // use bitwise XOR operation to detect the transition
end

endmodule