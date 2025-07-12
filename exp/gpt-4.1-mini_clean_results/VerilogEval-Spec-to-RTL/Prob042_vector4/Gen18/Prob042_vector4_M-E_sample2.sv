module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    always @(*) begin
        if (in[7] == 1'b1)
            out[31:8] = 24'hFFFFFF;  // replicate 1's for sign bit
        else
            out[31:8] = 24'h000000;  // replicate 0's for sign bit
        out[7:0] = in;
    end

endmodule