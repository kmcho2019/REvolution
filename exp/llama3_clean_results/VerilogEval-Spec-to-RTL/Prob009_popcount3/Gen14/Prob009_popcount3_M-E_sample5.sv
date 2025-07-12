module TopModule(
    input [2:0] in,
    output [1:0] out
);
    wire [1:0] count_1bit, count_2bit;

    // Counting the population count for the first bit
    assign count_1bit = in[0]? 2'b01 : 2'b00;

    // Counting the population count for the first two bits
    assign count_2bit = (in[1] + in[0]);

    // Using a multiplexer to select the correct count based on the MSB
    assign out = (in[2])? count_2bit + 1 : count_2bit;
endmodule