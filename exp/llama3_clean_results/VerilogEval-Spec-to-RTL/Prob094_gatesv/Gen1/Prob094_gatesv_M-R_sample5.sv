module TopModule(
    input  [3:0] in,
    output [2:0] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    // Internal signals to hold results before assignment to output ports
    wire [3:0] both_temp;
    wire [3:0] any_temp;
    wire [3:0] different_temp;

    // out_both
    assign both_temp[3] = in[3] & in[3]; // This bit isn't actually needed but included for consistency
    assign both_temp[2] = in[2] & in[3];
    assign both_temp[1] = in[1] & in[2];
    assign both_temp[0] = in[0] & in[1];

    assign out_both = both_temp[2:0]; // Assign only the relevant bits to out_both

    // out_any
    assign any_temp[2] = in[2] | in[1];
    assign any_temp[1] = in[1] | in[0];
    assign any_temp[0] = in[0] | in[0]; // This bit isn't actually needed but included for consistency
    assign any_temp[3] = 1'b0; // Not needed but included for completeness

    assign out_any = any_temp[2:0]; // Assign only the relevant bits to out_any

    // out_different
    assign different_temp[3] = in[3] ^ in[0]; // wrap around for the last bit
    assign different_temp[2] = in[2] ^ in[3];
    assign different_temp[1] = in[1] ^ in[2];
    assign different_temp[0] = in[0] ^ in[1];

    assign out_different = different_temp; // Assign all bits to out_different

endmodule