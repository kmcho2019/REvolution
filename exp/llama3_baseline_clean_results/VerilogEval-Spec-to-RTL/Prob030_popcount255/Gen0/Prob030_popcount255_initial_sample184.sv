module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit chunk
    wire [7:0] count0 [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            assign count0[i] = {8{1'b0}} + in[8*i+7:8*i];
        end
    endgenerate

    // Count the number of '1's in each 8-bit chunk of count0
    wire [7:0] count1 [3:0];
    generate
        for (i = 0; i < 4; i++) begin
            assign count1[i] = {8{1'b0}} + count0[8*i+7:8*i];
        end
    endgenerate

    // Count the number of '1's in each 8-bit chunk of count1
    wire [7:0] count2 [0:0];
    assign count2[0] = {8{1'b0}} + count1[3:0];

    // Sum up the counts
    assign out = count2[0];

endmodule