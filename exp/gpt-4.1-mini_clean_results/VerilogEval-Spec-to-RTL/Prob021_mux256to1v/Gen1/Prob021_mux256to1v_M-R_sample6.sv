module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output reg [3:0] out
);

    wire [9:0] start_bit;
    assign start_bit = sel << 2; // sel * 4

    always @(*) begin
        out = in[start_bit +: 4]; // select 4 bits starting at start_bit
    end

endmodule