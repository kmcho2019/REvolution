module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    wire [7:0] count_8bit [31:0];

    // Divide into 32 chunks of 8 bits and count '1's in each chunk
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            eight_bit_counter counter(.in(in[8*i +: 8]), .out(count_8bit[i]));
        end
    endgenerate

    // Add up counts from each chunk
    wire [7:0] sum;
    assign sum = count_8bit[0];
    for (i = 1; i < 32; i = i + 1) begin
        assign sum = sum + count_8bit[i];
    end

    // Limit the output to 8 bits (in case the sum exceeds 255)
    assign out = sum[7:0];
endmodule

// Module to count '1's in an 8-bit vector
module eight_bit_counter(in, out);
    input [7:0] in;
    output [7:0] out;

    assign out = {8{1'b0}} + in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
endmodule