module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

// Sequential logic to update the previous state
always @(posedge clk) begin
    prev_in <= in;  // update the previous state
end

// Combinational logic to detect the positive edge transition
assign pedge = in & (~prev_in);

endmodule