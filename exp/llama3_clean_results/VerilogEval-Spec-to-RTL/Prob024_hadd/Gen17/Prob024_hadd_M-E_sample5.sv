module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

    // Define the LUT for the half adder
    logic [1:0] lut[1:0];
    initial begin
        lut[0] = 2'b00;  // a=0, b=0: sum=0, cout=0
        lut[1] = 2'b01;  // a=0, b=1: sum=1, cout=0
        lut[2] = 2'b01;  // a=1, b=0: sum=1, cout=0
        lut[3] = 2'b10;  // a=1, b=1: sum=0, cout=1
    end

    // Access the LUT based on the input values
    assign {cout, sum} = lut[{a, b}];

endmodule