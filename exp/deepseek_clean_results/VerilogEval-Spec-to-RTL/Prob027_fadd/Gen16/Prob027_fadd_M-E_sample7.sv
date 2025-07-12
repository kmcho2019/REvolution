module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Combine inputs into a 3-bit vector
    wire [2:0] inputs = {a, b, cin};

    // Implement full adder as a lookup table
    always @(*) begin
        case(inputs)
            3'b000: {cout, sum} = 2'b00;
            3'b001: {cout, sum} = 2'b01;
            3'b010: {cout, sum} = 2'b01;
            3'b011: {cout, sum} = 2'b10;
            3'b100: {cout, sum} = 2'b01;
            3'b101: {cout, sum} = 2'b10;
            3'b110: {cout, sum} = 2'b10;
            3'b111: {cout, sum} = 2'b11;
            default: {cout, sum} = 2'b00;
        endcase
    end
endmodule