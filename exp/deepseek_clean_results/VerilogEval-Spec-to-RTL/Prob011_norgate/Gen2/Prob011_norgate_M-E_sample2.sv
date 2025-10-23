module TopModule(
    input a,
    input b,
    output out
);
    // LUT implementation of NOR gate
    wire [1:0] address = {a, b};
    reg [3:0] lut;

    initial begin
        // Initialize LUT with NOR truth table
        lut[0] = 1'b1;  // 00 -> 1
        lut[1] = 1'b0;  // 01 -> 0
        lut[2] = 1'b0;  // 10 -> 0
        lut[3] = 1'b0;  // 11 -> 0
    end

    assign out = lut[address];
endmodule