module TopModule (
    input in1,
    input in2,
    output out
);
    // 2-bit address ROM implementing the truth table
    reg [0:3] rom;
    initial begin
        rom[0] = 1'b0; // 00 -> 0
        rom[1] = 1'b0; // 01 -> 0
        rom[2] = 1'b1; // 10 -> 1
        rom[3] = 1'b0; // 11 -> 0
    end

    assign out = rom[{in1, in2}];
endmodule