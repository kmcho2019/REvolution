module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store the previous value of in

always @(posedge clk) begin
    prev_in <= in; // Update prev_in on every positive edge of clk
end

always @(posedge clk) begin
    anyedge <= (prev_in ^ in); // Calculate anyedge using XOR operation
end

endmodule