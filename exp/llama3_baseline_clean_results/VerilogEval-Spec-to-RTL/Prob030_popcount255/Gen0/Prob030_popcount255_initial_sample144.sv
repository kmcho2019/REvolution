module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Counting '1's in each byte (8 bits) of the input
    wire [7:0] byte_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            assign byte_counts[i] = 
                in[8*i+7] + in[8*i+6] + in[8*i+5] + in[8*i+4] + 
                in[8*i+3] + in[8*i+2] + in[8*i+1] + in[8*i+0];
        end
    endgenerate

    // Summing up counts from all bytes
    reg [7:0] sum;
    always @(byte_counts) begin
        sum = 8'd0;
        for (i = 0; i < 32; i++) begin
            sum = sum + byte_counts[i];
        end
    end

    assign out = sum;

endmodule