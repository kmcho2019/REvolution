module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Reverse the order of 20-bit groups
wire [19:0] group0 = in[19:0];
wire [19:0] group1 = in[39:20];
wire [19:0] group2 = in[59:40];
wire [19:0] group3 = in[79:60];
wire [19:0] group4 = in[99:80];

// Reverse bits within each group
function [19:0] reverse20;
    input [19:0] data;
    begin
        reverse20 = {data[0], data[1], data[2], data[3], data[4],
                    data[5], data[6], data[7], data[8], data[9],
                    data[10], data[11], data[12], data[13], data[14],
                    data[15], data[16], data[17], data[18], data[19]};
    end
endfunction

// Combine reversed groups in reverse order
assign out = {reverse20(group0), reverse20(group1), reverse20(group2),
              reverse20(group3), reverse20(group4)};

endmodule