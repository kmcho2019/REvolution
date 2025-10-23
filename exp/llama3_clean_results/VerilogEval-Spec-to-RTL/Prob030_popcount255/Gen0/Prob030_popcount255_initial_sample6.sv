module TopModule(
    input  [255:0] in,
    output [7:0] out
);

reg [7:0] count;

// Count the number of '1's in each byte (8 bits) of the input vector
reg [7:0] byte_count [31:0];
integer i;
always @(*) begin
    count = 0;
    for (i = 0; i < 32; i = i + 1) begin
        byte_count[i] = 8'd0;
        if (in[8*i+7]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+6]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+5]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+4]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+3]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+2]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+1]) byte_count[i] = byte_count[i] + 1;
        if (in[8*i+0]) byte_count[i] = byte_count[i] + 1;
        count = count + byte_count[i];
    end
    if (count > 255) out = 8'd255;
    else out = count;
end

endmodule