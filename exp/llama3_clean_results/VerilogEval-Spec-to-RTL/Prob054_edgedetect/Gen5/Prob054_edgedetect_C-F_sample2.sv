module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge[0] <= in[0] && ~prev_in[0];  // detect 0 to 1 transition using bitwise AND
    pedge[1] <= in[1] && ~prev_in[1];
    pedge[2] <= in[2] && ~prev_in[2];
    pedge[3] <= in[3] && ~prev_in[3];
    pedge[4] <= in[4] && ~prev_in[4];
    pedge[5] <= in[5] && ~prev_in[5];
    pedge[6] <= in[6] && ~prev_in[6];
    pedge[7] <= in[7] && ~prev_in[7];
end

endmodule