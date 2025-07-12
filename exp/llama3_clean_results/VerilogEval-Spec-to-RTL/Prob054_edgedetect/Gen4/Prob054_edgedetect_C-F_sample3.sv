module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    prev_in <= in; // update the previous value on every clock cycle
    pedge[0] <= ~prev_in[0] && in[0]; // directly assign the result of the edge detection for each bit
    pedge[1] <= ~prev_in[1] && in[1];
    pedge[2] <= ~prev_in[2] && in[2];
    pedge[3] <= ~prev_in[3] && in[3];
    pedge[4] <= ~prev_in[4] && in[4];
    pedge[5] <= ~prev_in[5] && in[5];
    pedge[6] <= ~prev_in[6] && in[6];
    pedge[7] <= ~prev_in[7] && in[7];
end

endmodule