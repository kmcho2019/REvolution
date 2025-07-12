module TopModule(
    input       clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous input vector

always @ (posedge clk) begin
    prev_in <= in;  // Update the previous input vector at every clock cycle
end

assign pedge = (in & ~prev_in);  // Detect positive edge by checking for bits that are high in 'in' but were low in 'prev_in'

endmodule