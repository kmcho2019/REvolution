module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    wire [2:0] shift_amount;
    integer i;

    // Calculate the total shift amount from ctrl bits:
    // ctrl[0] -> shift by 1
    // ctrl[1] -> shift by 2
    // ctrl[2] -> shift by 4
    assign shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            out[i] = in[(i + 8 - shift_amount) % 8]; // rotate left by shift_amount
        end
    end

endmodule