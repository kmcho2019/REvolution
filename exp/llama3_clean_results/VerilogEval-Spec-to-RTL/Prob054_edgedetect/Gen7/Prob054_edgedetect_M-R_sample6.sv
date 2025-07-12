module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
end

// combinational logic to detect 0 to 1 transitions
assign pedge = in & ~prev_in;

endmodule