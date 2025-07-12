module TopModule(
    input [255:0] in,
    output [7:0] out
);

    wire [15:0] count0, count1, count2, count3, count4;
    wire [7:0]  count5;

    // Level 1: Count 1's in each 16-bit sub-vector (16 sub-vectors)
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            popcount #(.WIDTH(16)) pc(
               .in(in[(i*16)+:16]),
               .out(count0[i])
            );
        end
    endgenerate

    // Level 2: Add counts from each 16-bit sub-vector (8 groups of 2 sub-vectors)
    genvar j;
    generate
        for (j = 0; j < 8; j++) begin
            adder #(.WIDTH(8)) a(
               .a(count0[j*2]),
               .b(count0[j*2+1]),
               .out(count1[j])
            );
        end
    endgenerate

    // Level 3: Add counts from each group of 2 sub-vectors (4 groups of 2)
    genvar k;
    generate
        for (k = 0; k < 4; k++) begin
            adder #(.WIDTH(8)) a(
               .a(count1[k*2]),
               .b(count1[k*2+1]),
               .out(count2[k])
            );
        end
    endgenerate

    // Level 4: Add counts from each group of 2 (2 groups of 2)
    genvar l;
    generate
        for (l = 0; l < 2; l++) begin
            adder #(.WIDTH(8)) a(
               .a(count2[l*2]),
               .b(count2[l*2+1]),
               .out(count3[l])
            );
        end
    endgenerate

    // Level 5: Add counts from each group of 2
    adder #(.WIDTH(8)) a(
       .a(count3[0]),
       .b(count3[1]),
       .out(count4[0])
    );

    // Final addition
    assign out = count4[0];

endmodule

module popcount #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] in,
    output [7:0] out
);

    reg [7:0] count;
    integer i;

    always @(*) begin
        count = 0;
        for (i = 0; i < WIDTH; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end

    assign out = count;

endmodule

module adder #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    assign out = a + b;

endmodule