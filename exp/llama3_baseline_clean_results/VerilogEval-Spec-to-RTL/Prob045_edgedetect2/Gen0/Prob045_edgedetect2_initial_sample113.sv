module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store previous input value

always @(posedge clk) begin
    prev_in <= in; // Update previous input value on each clock cycle
end

always @(*) begin
    anyedge = in ^ prev_in; // Detect edge transitions using XOR operation
end

endmodule