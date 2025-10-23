module TopModule(
    input           clk,
    input   [7:0]   in,
    output  [7:0]   pedge
);

reg [7:0] prev_in; // Register to store the previous state of in

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on every clock cycle
end

assign pedge = (in & ~prev_in); // Detect positive edges

endmodule