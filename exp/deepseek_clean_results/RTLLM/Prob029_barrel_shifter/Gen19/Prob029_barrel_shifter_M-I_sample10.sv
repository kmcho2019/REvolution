module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Internal wires between rotation stages
    wire [7:0] after_4bit_rot;  // After potential 4-bit right rotation
    wire [7:0] after_2bit_rot;  // After potential 2-bit right rotation

    // Pipeline of rotation stages
    right_rotate #(.SHIFT_AMOUNT(4)) rotate_4bit(
        .data_in(in),
        .enable(ctrl[2]),
        .data_out(after_4bit_rot)
    );

    right_rotate #(.SHIFT_AMOUNT(2)) rotate_2bit(
        .data_in(after_4bit_rot),
        .enable(ctrl[1]),
        .data_out(after_2bit_rot)
    );

    right_rotate #(.SHIFT_AMOUNT(1)) rotate_1bit(
        .data_in(after_2bit_rot),
        .enable(ctrl[0]),
        .data_out(out)
    );

endmodule

// Parameterized right rotation module
module right_rotate #(
    parameter SHIFT_AMOUNT = 1
)(
    input [7:0] data_in,
    input enable,
    output reg [7:0] data_out
);
    always @(*) begin
        if (enable)
            // Correct right rotation: lower SHIFT_AMOUNT bits move to MSBs
            data_out = {data_in[SHIFT_AMOUNT-1:0], data_in[7:SHIFT_AMOUNT]};
        else
            data_out = data_in;  // Pass-through when disabled
    end
endmodule