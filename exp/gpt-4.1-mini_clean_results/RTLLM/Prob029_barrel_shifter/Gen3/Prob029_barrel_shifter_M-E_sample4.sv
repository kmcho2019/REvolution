module barrel_shifter(
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    // Calculate total rotate amount from ctrl bits
    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);

    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Rotate right by shift_amount:
            // output bit i = input bit (i + shift_amount) mod 8
            out[i] = in[(i + shift_amount) % 8];
        end
    end

endmodule