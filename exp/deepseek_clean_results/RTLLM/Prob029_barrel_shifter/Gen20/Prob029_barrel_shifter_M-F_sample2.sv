module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Internal wires between shift stages
    wire [7:0] after_4bit_shift;  // After potential 4-bit right shift
    wire [7:0] after_2bit_shift;  // After potential 2-bit right shift

    // Pipeline of shift stages
    right_shift #(.SHIFT_AMOUNT(4)) shift_4bit(
        .data_in(in),
        .enable(ctrl[2]),
        .data_out(after_4bit_shift)
    );

    right_shift #(.SHIFT_AMOUNT(2)) shift_2bit(
        .data_in(after_4bit_shift),
        .enable(ctrl[1]),
        .data_out(after_2bit_shift)
    );

    right_shift #(.SHIFT_AMOUNT(1)) shift_1bit(
        .data_in(after_2bit_shift),
        .enable(ctrl[0]),
        .data_out(out)
    );

endmodule

// Parameterized right shift module (zero fill)
module right_shift #(
    parameter SHIFT_AMOUNT = 1
)(
    input [7:0] data_in,
    input enable,
    output reg [7:0] data_out
);
    always @(*) begin
        if (enable)
            // Right shift with zero fill
            data_out = {{SHIFT_AMOUNT{1'b0}}, data_in[7:SHIFT_AMOUNT]};
        else
            data_out = data_in;  // Pass-through when disabled
    end
endmodule