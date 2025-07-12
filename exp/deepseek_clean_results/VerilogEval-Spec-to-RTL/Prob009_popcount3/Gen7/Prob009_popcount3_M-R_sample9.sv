module TopModule (
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] sum;
    assign sum[0] = in[0] ^ in[1] ^ in[2];          // Sum LSB
    assign sum[1] = (in[0] & in[1]) |               // Carry from first two bits
                   ((in[0] | in[1]) & in[2]);       // Or carry from third bit with any previous
    assign out = sum;

endmodule