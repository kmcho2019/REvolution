module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        casez(in)
            4'b1xxx: pos = 2'b11;  // Most significant bit is 1
            4'b01xx: pos = 2'b10;  // Second most significant bit is 1
            4'b001x: pos = 2'b01;  // Third most significant bit is 1
            4'b0001: pos = 2'b00;  // Least significant bit is 1
            default: pos = 2'b00; // No 1 bit found, output 0
        endcase
    end

endmodule