module TopModule (
    input [2:0] in,
    output [1:0] out
);
    wire [1:0] temp_sum;
    
    assign temp_sum = in[0] + in[1];
    assign out = temp_sum + in[2];
endmodule