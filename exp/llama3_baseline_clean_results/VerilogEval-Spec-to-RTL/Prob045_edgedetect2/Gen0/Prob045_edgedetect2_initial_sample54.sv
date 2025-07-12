module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= (in ^ prev_in); // XOR operation to detect edges
    prev_in <= in; // Update previous input value
end

endmodule