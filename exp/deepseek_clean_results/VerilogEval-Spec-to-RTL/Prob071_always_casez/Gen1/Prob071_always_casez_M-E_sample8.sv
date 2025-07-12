module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] sel_lower = {|in[7:4], |in[3:0]};
wire [3:0] mux_in = sel_lower[1] ? in[7:4] : in[3:0];
wire [1:0] sel_upper = {|mux_in[3:2], |mux_in[1:0]};
wire [1:0] mux_final = sel_upper[1] ? mux_in[3:2] : mux_in[1:0];

assign pos[2] = sel_lower[1];
assign pos[1] = sel_upper[1];
assign pos[0] = mux_final[0] ? 1'b0 : 1'b1;

endmodule