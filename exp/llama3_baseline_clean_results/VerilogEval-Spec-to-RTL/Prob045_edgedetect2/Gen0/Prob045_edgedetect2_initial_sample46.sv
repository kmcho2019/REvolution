module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store previous state of input vector
reg [7:0] anyedge; // Register to store output

always @ (posedge clk) begin
    anyedge <= prev_in ^ in; // XOR operation to detect any edge
    prev_in <= in; // Update previous state
end

endmodule