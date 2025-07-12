module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous state of the input vector

always @(posedge clk) begin
    // update the previous state register at every positive clock edge
    prev_in <= in;
end

// combinatorial logic to detect positive edges
assign pedge = ~prev_in & in;

endmodule