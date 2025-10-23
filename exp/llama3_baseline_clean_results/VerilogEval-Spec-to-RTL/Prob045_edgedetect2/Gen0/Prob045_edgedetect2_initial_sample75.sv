module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= (in ^ prev_in); // XOR operation to detect any transition
    prev_in <= in; // Update previous state
end

endmodule