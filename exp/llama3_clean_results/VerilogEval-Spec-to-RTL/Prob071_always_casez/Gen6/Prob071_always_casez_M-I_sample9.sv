module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    // Group the input into 4 groups of 2 bits
    wire [1:0] group0 = in[1:0];
    wire [1:0] group1 = in[3:2];
    wire [1:0] group2 = in[5:4];
    wire [1:0] group3 = in[7:6];

    // Find the first '1' in each group and encode its position
    wire [1:0] enc0;
    assign enc0 = (group0[1]) ? 2'b10 : (group0[0]) ? 2'b01 : 2'b00;

    wire [1:0] enc1;
    assign enc1 = (group1[1]) ? 2'b10 : (group1[0]) ? 2'b01 : 2'b00;

    wire [1:0] enc2;
    assign enc2 = (group2[1]) ? 2'b10 : (group2[0]) ? 2'b01 : 2'b00;

    wire [1:0] enc3;
    assign enc3 = (group3[1]) ? 2'b10 : (group3[0]) ? 2'b01 : 2'b00;

    // Use a higher-level priority encoder to select the first '1'
    wire [1:0] first_group;
    assign first_group = (
        (enc0 != 2'b00) ? 2'b00 :
        (enc1 != 2'b00) ? 2'b01 :
        (enc2 != 2'b00) ? 2'b10 :
        (enc3 != 2'b00) ? 2'b11 : 2'b00
    );

    // Determine the final position
    assign pos = (
        (first_group == 2'b00) ? {1'b0, enc0} :
        (first_group == 2'b01) ? {1'b1, enc1} :
        (first_group == 2'b10) ? {1'b1, enc2} :
        (first_group == 2'b11) ? {1'b1, enc3} : 3'b000
    );

endmodule