module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [2:0] shift_amount = (ctrl[2] ? 3'd4 : 3'd0) + (ctrl[1] ? 3'd2 : 3'd0) + (ctrl[0] ? 3'd1 : 3'd0);

    assign out = (in >> shift_amount) | (in << (8 - shift_amount));

endmodule