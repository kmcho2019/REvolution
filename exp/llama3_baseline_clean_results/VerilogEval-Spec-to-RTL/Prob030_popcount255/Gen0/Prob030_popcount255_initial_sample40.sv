module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Calculate population count for each byte
    wire [7:0] byte_count [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: gen_byte_count
            assign byte_count[i] = {8{1'b0}} + 
                in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8+0];
        end
    endgenerate

    // Sum up all the byte counts
    reg [7:0] sum;
    always @(*) begin
        sum = 8'd0;
        for (int i = 0; i < 32; i = i + 1) begin
            sum = sum + byte_count[i];
        end
        out = sum;
    end

endmodule