module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input vector

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state on every clock cycle
end

always @(*) begin
    // Detect positive edges by comparing the current input with the previous state
    // A positive edge is detected when the current bit is 1 and the corresponding previous bit is 0
    pedge = in & ~prev_in;
end

endmodule