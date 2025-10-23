module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous input

always @(posedge clk) begin
    // Store the current input in the previous input register
    prev_in <= in;
end

// Combinational logic to detect the positive edge
assign pedge = (in & (~prev_in));

endmodule