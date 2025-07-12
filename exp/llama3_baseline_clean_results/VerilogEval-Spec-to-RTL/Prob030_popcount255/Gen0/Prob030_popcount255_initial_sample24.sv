module TopModule(in, out);
    input [254:0] in;
    output [7:0] out;

    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7, count8;
    wire [7:0] temp0, temp1, temp2, temp3;

    // Population count for each 32-bit group
    popcount #(.WIDTH(32)) u0(.in(in[31:0]), .out(count0));
    popcount #(.WIDTH(32)) u1(.in(in[63:32]), .out(count1));
    popcount #(.WIDTH(32)) u2(.in(in[95:64]), .out(count2));
    popcount #(.WIDTH(32)) u3(.in(in[127:96]), .out(count3));
    popcount #(.WIDTH(32)) u4(.in(in[159:128]), .out(count4));
    popcount #(.WIDTH(32)) u5(.in(in[191:160]), .out(count5));
    popcount #(.WIDTH(32)) u6(.in(in[223:192]), .out(count6));
    popcount #(.WIDTH(32)) u7(.in(in[255:224]), .out(count7));
    popcount #(.WIDTH(7)) u8(.in(in[254:248]), .out(count8));

    // Sum up counts from each group
    adder8 u9(.in0(count0), .in1(count1), .out(temp0));
    adder8 u10(.in0(count2), .in1(count3), .out(temp1));
    adder8 u11(.in0(count4), .in1(count5), .out(temp2));
    adder8 u12(.in0(count6), .in1(count7), .out(temp3));

    adder8 u13(.in0(temp0), .in1(temp1), .out(temp0));
    adder8 u14(.in0(temp2), .in1(temp3), .out(temp1));

    adder8 u15(.in0(temp0), .in1(temp1), .out(temp0));

    adder8 u16(.in0(temp0), .in1(count8), .out(out));

endmodule

module popcount #(parameter WIDTH = 8)(in, out);
    input [WIDTH-1:0] in;
    output [7:0] out;

    wire [7:0] count;

    assign count = { {(in[WIDTH-1] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-2] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-3] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-4] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-5] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-6] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-7] == 1'b1) ? 1'b1 : 1'b0} | 
                    {(in[WIDTH-8] == 1'b1) ? 1'b1 : 1'b0} };

    assign out = (WIDTH > 8) ? {count + in[WIDTH-1:8], 8'b0} : count;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign count[i] = (in[i] == 1'b1) ? 1'b1 : 1'b0;
        end
    endgenerate
endmodule

module adder8(in0, in1, out);
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = in0 + in1;
endmodule