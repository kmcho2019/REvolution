module TopModule (
    input [254:0] in,
    output [7:0] out
);

    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7;
    wire [7:0] temp0, temp1, temp2, temp3;

    // Count the number of '1's in each 32-bit group
    ones_counter #(.WIDTH(32)) ones_counter0 (.in(in[31:0]), .out(count0));
    ones_counter #(.WIDTH(32)) ones_counter1 (.in(in[63:32]), .out(count1));
    ones_counter #(.WIDTH(32)) ones_counter2 (.in(in[95:64]), .out(count2));
    ones_counter #(.WIDTH(32)) ones_counter3 (.in(in[127:96]), .out(count3));
    ones_counter #(.WIDTH(32)) ones_counter4 (.in(in[159:128]), .out(count4));
    ones_counter #(.WIDTH(32)) ones_counter5 (.in(in[191:160]), .out(count5));
    ones_counter #(.WIDTH(32)) ones_counter6 (.in(in[223:192]), .out(count6));
    ones_counter #(.WIDTH(7)) ones_counter7 (.in(in[254:223]), .out(count7));

    // Add up the counts from each group
    adder #(.WIDTH(8)) adder0 (.in0(count0), .in1(count1), .out(temp0));
    adder #(.WIDTH(8)) adder1 (.in0(count2), .in1(count3), .out(temp1));
    adder #(.WIDTH(8)) adder2 (.in0(count4), .in1(count5), .out(temp2));
    adder #(.WIDTH(8)) adder3 (.in0(count6), .in1(count7), .out(temp3));
    adder #(.WIDTH(8)) adder4 (.in0(temp0), .in1(temp1), .out(temp0));
    adder #(.WIDTH(8)) adder5 (.in0(temp2), .in1(temp3), .out(temp1));
    adder #(.WIDTH(8)) adder6 (.in0(temp0), .in1(temp1), .out(out));

endmodule

module ones_counter #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] in,
    output [7:0] out
);

    reg [7:0] count;
    integer i;

    always @(in) begin
        count = 0;
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
        out <= count;
    end

endmodule

module adder #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    output [WIDTH-1:0] out
);

    assign out = in0 + in1;

endmodule