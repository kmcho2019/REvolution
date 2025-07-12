module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    reg [2:0] bit_count;

    always @* begin
        bit_count = in[0] + in[1] + in[2];
        out = bit_count[1:0];
    end

endmodule