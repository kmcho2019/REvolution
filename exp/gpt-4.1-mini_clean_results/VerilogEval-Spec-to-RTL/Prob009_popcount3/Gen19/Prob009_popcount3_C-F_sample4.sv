module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    wire [2:0] sum_bits;
    assign sum_bits = in[0] + in[1] + in[2];

    always @(*) begin
        out = sum_bits[1:0];
    end

endmodule