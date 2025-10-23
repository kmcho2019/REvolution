module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in; // Internal register to store the previous state of in

always @(posedge clk) begin
    // Update prev_in with the current value of in
    prev_in <= in;
    // Check for any edge (0->1 or 1->0 transition) and update anyedge accordingly
    anyedge <= ~prev_in & in | prev_in & ~in;
end

endmodule