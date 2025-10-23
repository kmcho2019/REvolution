module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

// Sequential logic to update the previous state at each clock edge
always @(posedge clk) begin
    prev_in <= in;  // update the previous state
end

// Combinational logic to detect the positive edge transition
assign pedge[0] = in[0] && ~prev_in[0];
assign pedge[1] = in[1] && ~prev_in[1];
assign pedge[2] = in[2] && ~prev_in[2];
assign pedge[3] = in[3] && ~prev_in[3];
assign pedge[4] = in[4] && ~prev_in[4];
assign pedge[5] = in[5] && ~prev_in[5];
assign pedge[6] = in[6] && ~prev_in[6];
assign pedge[7] = in[7] && ~prev_in[7];

endmodule