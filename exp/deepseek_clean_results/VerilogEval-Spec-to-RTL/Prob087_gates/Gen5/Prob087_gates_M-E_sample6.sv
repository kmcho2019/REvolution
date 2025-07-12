module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Combine inputs into a 2-bit vector for case statement
    wire [1:0] ab = {a, b};

    // Use a case statement to implement all gates as a truth table
    reg [6:0] gates; // [6:0] maps to out_anotb to out_and (LSB)
    always @(*) begin
        case (ab)
            2'b00: gates = 7'b0110100;
            2'b01: gates = 7'b1011010;
            2'b10: gates = 7'b1101001;
            2'b11: gates = 7'b1000011;
        endcase
    end

    // Split the gates register into individual outputs
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = gates;

endmodule