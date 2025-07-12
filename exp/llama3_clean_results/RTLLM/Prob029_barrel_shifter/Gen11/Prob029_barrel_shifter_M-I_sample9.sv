// Improved 8-bit Barrel Shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Generate all possible shifts in parallel
    wire [7:0] shift_4 = {in[3:0], in[7:4]};
    wire [7:0] shift_2 = {in[5:0], in[7:6]};
    wire [7:0] shift_1 = {in[6:0], in[7]};

    // Use a multiplexer tree to select the appropriate shift based on the control signal
    wire [7:0] out_4 = ctrl[2]? shift_4 : in;
    wire [7:0] out_2 = ctrl[1]? shift_2 : out_4;
    assign out = ctrl[0]? shift_1 : out_2;

endmodule