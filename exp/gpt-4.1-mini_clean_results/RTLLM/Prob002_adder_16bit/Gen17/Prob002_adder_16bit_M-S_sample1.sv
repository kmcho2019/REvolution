module adder_param #(parameter WIDTH = 16) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              Cin,
    output [WIDTH-1:0] y,
    output             Co
);
    wire [WIDTH:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign Co = carry[WIDTH];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    adder_param #(.WIDTH(16)) adder_inst (
        .a(a),
        .b(b),
        .Cin(Cin),
        .y(y),
        .Co(Co)
    );
endmodule