// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Calculate the total shift amount
    reg [2:0] shift_amount;
    always @(*) begin
        shift_amount = (ctrl[2] << 2) + (ctrl[1] << 1) + ctrl[0];
    end

    // Shift the input by the total shift amount and rotate the bits
    reg [7:0] shifted;
    always @(*) begin
        shifted = {in[(7 - shift_amount) % 8 +: 8], in[:(7 - shift_amount) % 8]};
    end

    assign out = shifted;

endmodule