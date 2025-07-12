module TopModule (
    input  [254:0] in,  // 255-bit input vector
    output [7:0] out   // 8-bit output
);

    // Count the number of '1's in each 32-bit group
    wire [7:0] count_0;
    wire [7:0] count_1;
    wire [7:0] count_2;
    wire [7:0] count_3;
    wire [7:0] count_4;
    wire [7:0] count_5;
    wire [7:0] count_6;
    wire [7:0] count_7;
    wire [7:0] count_8;

    // 255-bit to 8 groups of 32-bit (with 7 bits left over)
    PopulationCount #(.WIDTH(32)) pc_0 (.in(in[31:0]), .out(count_0));
    PopulationCount #(.WIDTH(32)) pc_1 (.in(in[63:32]), .out(count_1));
    PopulationCount #(.WIDTH(32)) pc_2 (.in(in[95:64]), .out(count_2));
    PopulationCount #(.WIDTH(32)) pc_3 (.in(in[127:96]), .out(count_3));
    PopulationCount #(.WIDTH(32)) pc_4 (.in(in[159:128]), .out(count_4));
    PopulationCount #(.WIDTH(32)) pc_5 (.in(in[191:160]), .out(count_5));
    PopulationCount #(.WIDTH(32)) pc_6 (.in(in[223:192]), .out(count_6));
    PopulationCount #(.WIDTH(32)) pc_7 (.in(in[255:224]), .out(count_7));

    // Count the number of '1's in the remaining 7 bits
    PopulationCount #(.WIDTH(7)) pc_8 (.in(in[254:248]), .out(count_8));

    // Add up the counts
    wire [8:0] sum_0;
    wire [8:0] sum_1;
    wire [8:0] sum_2;
    wire [8:0] sum_3;

    assign sum_0 = count_0 + count_1;
    assign sum_1 = count_2 + count_3;
    assign sum_2 = count_4 + count_5;
    assign sum_3 = count_6 + count_7;

    wire [9:0] sum_4;
    wire [9:0] sum_5;
    assign sum_4 = {1'b0, sum_0} + {1'b0, sum_1};
    assign sum_5 = {1'b0, sum_2} + {1'b0, sum_3};

    wire [10:0] sum_6;
    assign sum_6 = {1'b0, sum_4} + {1'b0, sum_5};

    assign out = sum_6[8:1] + count_8;

endmodule

// Population Count module
module PopulationCount #(
    parameter WIDTH = 32
) (
    input  [WIDTH-1:0] in,
    output [7:0] out
);

    reg [WIDTH-1:0] temp;
    reg [7:0] count;
    integer i;

    always @(in) begin
        count = 0;
        temp = in;
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (temp[i] == 1'b1) begin
                count = count + 1;
            end
        end
        out = count;
    end

endmodule