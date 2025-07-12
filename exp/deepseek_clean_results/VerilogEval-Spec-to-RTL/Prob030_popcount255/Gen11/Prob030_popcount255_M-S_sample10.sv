module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Count 8-bit chunks (31 chunks of 8 bits + 7 remaining bits)
    wire [3:0] count8 [0:30];  // 4 bits needed (max 8)
    wire [2:0] count7;         // 3 bits needed (max 7)
    
    genvar i;
    generate
        // Count 31 chunks of 8 bits
        for (i = 0; i < 31; i = i + 1) begin : count8_blocks
            assign count8[i] = in[i*8] + in[i*8+1] + in[i*8+2] + in[i*8+3] +
                              in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
        end
        
        // Count remaining 7 bits
        assign count7 = in[248] + in[249] + in[250] + in[251] +
                        in[252] + in[253] + in[254];
    endgenerate

    // Sum all counts
    reg [7:0] total;
    integer j;
    always @(*) begin
        total = count7;
        for (j = 0; j < 31; j = j + 1) begin
            total = total + count8[j];
        end
    end

    assign out = total;

endmodule