module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    // Define a 16-bit population count function
    function [4:0] popcount16;
        input [15:0] in;
        reg [4:0] count;
        begin
            count = 0;
            for (int i = 0; i < 16; i++) begin
                if (in[i]) count = count + 1;
            end
            popcount16 = count;
        end
    endfunction

    // Define a 8-bit population count function
    function [3:0] popcount8;
        input [7:0] in;
        reg [3:0] count;
        begin
            count = 0;
            for (int i = 0; i < 8; i++) begin
                if (in[i]) count = count + 1;
            end
            popcount8 = count;
        end
    endfunction

    // Define a 7-bit population count function
    function [2:0] popcount7;
        input [6:0] in;
        reg [2:0] count;
        begin
            count = 0;
            for (int i = 0; i < 7; i++) begin
                if (in[i]) count = count + 1;
            end
            popcount7 = count;
        end
    endfunction

    // Calculate population count for each group
    reg [4:0] count15;
    reg [4:0] count14;
    reg [4:0] count13;
    reg [4:0] count12;
    reg [4:0] count11;
    reg [4:0] count10;
    reg [4:0] count9;
    reg [4:0] count8;
    reg [4:0] count7;
    reg [4:0] count6;
    reg [4:0] count5;
    reg [4:0] count4;
    reg [4:0] count3;
    reg [4:0] count2;
    reg [4:0] count1;
    reg [4:0] count0;
    reg [3:0] count_remainder;

    assign count15 = popcount16(in[255:240]);
    assign count14 = popcount16(in[239:224]);
    assign count13 = popcount16(in[223:208]);
    assign count12 = popcount16(in[207:192]);
    assign count11 = popcount16(in[191:176]);
    assign count10 = popcount16(in[175:160]);
    assign count9 = popcount16(in[159:144]);
    assign count8 = popcount16(in[143:128]);
    assign count7 = popcount16(in[127:112]);
    assign count6 = popcount16(in[111:96]);
    assign count5 = popcount16(in[95:80]);
    assign count4 = popcount16(in[79:64]);
    assign count3 = popcount16(in[63:48]);
    assign count2 = popcount16(in[47:32]);
    assign count1 = popcount16(in[31:16]);
    assign count0 = popcount16(in[15:0]);
    assign count_remainder = popcount7(in[7:0]);

    // Calculate total population count
    reg [7:0] total_count;
    assign total_count = count15 + count14 + count13 + count12 + count11 + count10 + count9 + count8 + count7 + count6 + count5 + count4 + count3 + count2 + count1 + count0 + count_remainder;

    // Assign output
    assign out = total_count[7:0];

endmodule