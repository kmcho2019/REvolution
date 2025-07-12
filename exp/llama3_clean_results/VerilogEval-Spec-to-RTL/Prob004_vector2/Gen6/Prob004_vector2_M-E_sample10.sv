module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    reg [31:0] temp;

    always @(*) begin
        temp = in;
        out[7:0]   = temp[31-7:31-8];
        out[15:8]  = temp[31-15:31-16];
        out[23:16] = temp[31-23:31-24];
        out[31:24] = temp[31-31:31-32];
    end

endmodule