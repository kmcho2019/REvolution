module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Gated partial product generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : PP_GEN
            assign pp[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Wallace tree reduction (4:2 compressor)
    wire [15:0] s1, c1, s2, c2;
    wire [15:0] s3, c3, s4, c4;

    // First level compression
    assign {c1, s1} = pp[0] + pp[1] + pp[2];
    assign {c2, s2} = pp[3] + pp[4] + pp[5];

    // Second level compression
    assign {c3, s3} = s1 + c1 + s2;
    assign {c4, s4} = c2 + pp[6] + pp[7];

    // Final carry-select adder
    always @(*) begin
        product = s3 + s4 + (c3 << 1) + (c4 << 1);
    end

endmodule