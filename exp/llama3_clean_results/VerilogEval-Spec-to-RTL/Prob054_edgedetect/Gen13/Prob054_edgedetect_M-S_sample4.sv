module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge[0] <= in[0] && ~prev_in[0];  // detect 0 to 1 transition using bitwise AND
    pedge[1] <= in[1] && ~prev_in[1];  // detect 0 to 1 transition using bitwise AND
    pedge[2] <= in[2] && ~prev_in[2];  // detect 0 to 1 transition using bitwise AND
    pedge[3] <= in[3] && ~prev_in[3];  // detect 0 to 1 transition using bitwise AND
    pedge[4] <= in[4] && ~prev_in[4];  // detect 0 to 1 transition using bitwise AND
    pedge[5] <= in[5] && ~prev_in[5];  // detect 0 to 1 transition using bitwise AND
    pedge[6] <= in[6] && ~prev_in[6];  // detect 0 to 1 transition using bitwise AND
    pedge[7] <= in[7] && ~prev_in[7];  // detect 0 to 1 transition using bitwise AND
end

endmodule