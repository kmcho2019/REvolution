module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Precompute all possible shift amounts
    wire [7:0] shift_4 = {in[3:0], in[7:4]};  // Rotate right by 4
    wire [7:0] shift_2 = {in[1:0], in[7:2]};  // Rotate right by 2
    wire [7:0] shift_1 = {in[0], in[7:1]};    // Rotate right by 1

    // First level mux: select between 0 or 4 shift
    wire [7:0] mux_level1 = ctrl[2] ? shift_4 : in;

    // Second level mux: select between 0 or 2 shift of first level result
    wire [7:0] mux_level2 = ctrl[1] ? 
                           {mux_level1[1:0], mux_level1[7:2]} : 
                           mux_level1;

    // Third level mux: select between 0 or 1 shift of second level result
    assign out = ctrl[0] ? 
                {mux_level2[0], mux_level2[7:1]} : 
                mux_level2;
endmodule