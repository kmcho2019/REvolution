module TopModule(
    input  [1023:0] in,  // 1024-bit input vector
    input  [7:0] sel,   // 8-bit select signal
    output [3:0] out    // 4-bit output
);

    // Generate control signals based on the select value
    wire [255:0] ctrl;
    assign ctrl = (1 << sel);

    // Extract the 4-bit group from the input vector using the control signals
    wire [3:0] out_temp;
    assign out_temp[0] = (in[4*sel + 0] & ctrl[0]) | (in[4*sel + 0] & ctrl[1]) | (in[4*sel + 0] & ctrl[2]) | (in[4*sel + 0] & ctrl[3]);
    assign out_temp[1] = (in[4*sel + 1] & ctrl[0]) | (in[4*sel + 1] & ctrl[1]) | (in[4*sel + 1] & ctrl[2]) | (in[4*sel + 1] & ctrl[3]);
    assign out_temp[2] = (in[4*sel + 2] & ctrl[0]) | (in[4*sel + 2] & ctrl[1]) | (in[4*sel + 2] & ctrl[2]) | (in[4*sel + 2] & ctrl[3]);
    assign out_temp[3] = (in[4*sel + 3] & ctrl[0]) | (in[4*sel + 3] & ctrl[1]) | (in[4*sel + 3] & ctrl[2]) | (in[4*sel + 3] & ctrl[3]);

    assign out = out_temp;

endmodule