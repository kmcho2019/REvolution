module TopModule(
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    reg [7:0] byte0;
    reg [7:0] byte1;
    reg sel0, sel1;

    always @* begin
        byte0 = in[7:0];
        byte1 = in[15:8];
        sel0 = 1'b0; // Select lower byte for out_lo
        sel1 = 1'b1; // Select upper byte for out_hi

        case(sel0)
            1'b0: out_lo = byte0;
            1'b1: out_lo = byte1;
        endcase

        case(sel1)
            1'b0: out_hi = byte0;
            1'b1: out_hi = byte1;
        endcase
    end

endmodule