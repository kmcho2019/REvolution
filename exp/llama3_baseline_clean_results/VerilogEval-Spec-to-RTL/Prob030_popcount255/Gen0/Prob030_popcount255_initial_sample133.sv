module counter_32bit(input [31:0] in, output [7:0] out);
    always @(in) begin
        out = 8'd0;
        for (int i = 0; i < 32; i++) begin
            if (in[i]) begin
                out = out + 1;
            end
        end
    end
endmodule

module TopModule(input [254:0] in, output [7:0] out);
    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7;
    counter_32bit u0 (.in(in[ 31: 0]), .out(count0));
    counter_32bit u1 (.in(in[ 63:32]), .out(count1));
    counter_32bit u2 (.in(in[ 95:64]), .out(count2));
    counter_32bit u3 (.in(in[127:96]), .out(count3));
    counter_32bit u4 (.in(in[159:128]), .out(count4));
    counter_32bit u5 (.in(in[191:160]), .out(count5));
    counter_32bit u6 (.in(in[223:192]), .out(count6));
    counter_32bit u7 (.in({in[254:224], 5'd0}), .out(count7));
    
    assign out = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7;
endmodule