module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Store previous value of in

always @(posedge clk) begin
    prev_in <= in; // Update previous value on positive edge of clk
end

always @(*) begin
    anyedge = in ^ prev_in; // Detect any edge using XOR
end

endmodule