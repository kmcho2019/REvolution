module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

// Register the input to hold previous cycle's input value
always @(posedge clk) begin
    prev_in <= in;
end

// Output pedge bits: detect 0->1 transitions from prev_in to current input
assign pedge = (~prev_in) & in;

endmodule