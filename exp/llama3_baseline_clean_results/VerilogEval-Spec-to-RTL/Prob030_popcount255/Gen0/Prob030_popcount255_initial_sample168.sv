module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count;

    assign out = count;

    // Divide the 255-bit input into 8 groups of 32 bits (one bit left over)
    wire [31:0] group0 = in[31:0];
    wire [31:0] group1 = in[63:32];
    wire [31:0] group2 = in[95:64];
    wire [31:0] group3 = in[127:96];
    wire [31:0] group4 = in[159:128];
    wire [31:0] group5 = in[191:160];
    wire [31:0] group6 = in[223:192];
    wire [31:0] group7 = in[254:224];

    // Count the number of '1's in each group
    wire [4:0] count0;
    wire [4:0] count1;
    wire [4:0] count2;
    wire [4:0] count3;
    wire [4:0] count4;
    wire [4:0] count5;
    wire [4:0] count6;
    wire [4:0] count7;

    // Use a population count module to count the number of '1's in each group
    PopCount #(.WIDTH(32)) popcount0(.in(group0), .out(count0));
    PopCount #(.WIDTH(32)) popcount1(.in(group1), .out(count1));
    PopCount #(.WIDTH(32)) popcount2(.in(group2), .out(count2));
    PopCount #(.WIDTH(32)) popcount3(.in(group3), .out(count3));
    PopCount #(.WIDTH(32)) popcount4(.in(group4), .out(count4));
    PopCount #(.WIDTH(32)) popcount5(.in(group5), .out(count5));
    PopCount #(.WIDTH(32)) popcount6(.in(group6), .out(count6));
    PopCount #(.WIDTH(32)) popcount7(.in(group7), .out(count7));

    // Sum up the counts from each group
    assign count = {3'b0, count0[4:0]} + {3'b0, count1[4:0]} + {3'b0, count2[4:0]} + {3'b0, count3[4:0]} +
                   {3'b0, count4[4:0]} + {3'b0, count5[4:0]} + {3'b0, count6[4:0]} + {3'b0, count7[4:0]};

endmodule

// Population count module
module PopCount #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] count;
    integer i;

    always @(*) begin
        count = 0;
        for (i = 0; i < WIDTH; i++) begin
            if (in[i]) begin
                count = count + 1;
            end
        end
        out = count;
    end

endmodule