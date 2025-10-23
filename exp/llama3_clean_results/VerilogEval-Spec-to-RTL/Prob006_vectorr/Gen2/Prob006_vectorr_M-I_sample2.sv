module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, for better readability and potential synthesis efficiency:
    // assign out = in[0]? 8'b00000001 : (in[1]? 8'b00000010 : (in[2]? 8'b00000100 : (in[3]? 8'b00001000 : (in[4]? 8'b00010000 : (in[5]? 8'b00100000 : (in[6]? 8'b01000000 : 8'b10000000))))));

    // But a more Verilog-idiomatic way to reverse bits would be:
    // assign out = in << 8 - 8;

    // However, the most straightforward and efficient way remains the original assignment:
    // assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // For a parametrizable solution:
    // parameter WIDTH = 8;
    // input  [WIDTH-1:0] in;
    // output [WIDTH-1:0] out;
    // assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    // Or more generally for any width:
    // assign out = in[0]? 1 : 0; // placeholder, real solution would involve a loop or a parameterized concatenation

    // The most general and efficient solution for any width, however, would indeed leverage a for loop or a parameterized expression to reverse the bits:
    // For a generic bit reversal:
    genvar i;
    for (i = 0; i < 8; i++) begin
        assign out[i] = in[7-i];
    end

endmodule