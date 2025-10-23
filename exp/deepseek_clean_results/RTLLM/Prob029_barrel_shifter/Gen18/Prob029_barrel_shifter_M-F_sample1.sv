module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Internal wires between shift stages
    wire [7:0] stage1_out;  // After potential 4-bit right rotation
    wire [7:0] stage2_out;  // After potential 2-bit right rotation

    // Instantiate shift modules in pipeline
    right_rotate #(.SHIFT(4)) rotate_4bit(
        .data_in(in),
        .enable(ctrl[2]),
        .data_out(stage1_out)
    );

    right_rotate #(.SHIFT(2)) rotate_2bit(
        .data_in(stage1_out),
        .enable(ctrl[1]),
        .data_out(stage2_out)
    );

    right_rotate #(.SHIFT(1)) rotate_1bit(
        .data_in(stage2_out),
        .enable(ctrl[0]),
        .data_out(out)
    );

endmodule

// Parameterized right rotation module
module right_rotate #(
    parameter SHIFT = 1
)(
    input [7:0] data_in,
    input enable,
    output reg [7:0] data_out
);
    always @(*) begin
        if (enable)
            // Right rotation: lower SHIFT bits wrap around to the top
            data_out = {data_in[SHIFT-1:0], data_in[7:SHIFT]};
        else
            data_out = data_in;
    end
endmodule