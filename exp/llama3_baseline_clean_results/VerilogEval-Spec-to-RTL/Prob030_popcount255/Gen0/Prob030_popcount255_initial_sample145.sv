module TopModule(
    input [254:0] in,  // 255-bit input vector
    output [7:0] out  // 8-bit output
);

// Count the number of '1's in each byte (8 bits) of the input vector
reg [7:0] byte_counts [31:0];

// Initialize a counter for each byte
integer i;
always @(*) begin
    for (i = 0; i < 32; i++) begin
        reg [7:0] byte = in[(i*8)+7:(i*8)];
        reg [3:0] count = 4'b0;
        // Count the number of '1's in the current byte
        if (byte[0]) count = count + 1;
        if (byte[1]) count = count + 1;
        if (byte[2]) count = count + 1;
        if (byte[3]) count = count + 1;
        if (byte[4]) count = count + 1;
        if (byte[5]) count = count + 1;
        if (byte[6]) count = count + 1;
        if (byte[7]) count = count + 1;
        byte_counts[i] = count;
    end
end

// Sum up the counts from each byte
reg [7:0] sum;
always @(*) begin
    sum = 8'b0;
    for (i = 0; i < 32; i++) begin
        sum = sum + byte_counts[i];
    end
end

// Assign the sum to the output
assign out = sum;

endmodule