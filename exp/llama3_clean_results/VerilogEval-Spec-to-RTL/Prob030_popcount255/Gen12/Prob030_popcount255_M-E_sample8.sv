module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
genvar i;
for (i = 0; i < 32; i++) begin
    if (i == 31) begin
        assign segment[i] = {1'b0, in[254:248]};
    end else begin
        assign segment[i] = in[(i*8)+7:i*8];
    end
end

// Population counts for each segment
wire [4:0] segment_count [31:0];

// Assign the population counts using a lookup table
wire [4:0] lookup_table [255:0];
for (i = 0; i < 256; i++) begin
    assign lookup_table[i] = $countones(i);
end

for (i = 0; i < 32; i++) begin
    assign segment_count[i] = lookup_table[segment[i]];
end

// Shift register to store the segment counts
reg [4:0] shift_reg [31:0];
integer j;
always @(posedge clk) begin
    for (j = 31; j > 0; j--) begin
        shift_reg[j] <= shift_reg[j-1];
    end
    shift_reg[0] <= segment_count[0];
end

// Serial adder to accumulate the population counts
reg [7:0] count;
always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else begin
        count <= count + shift_reg[31];
    end
end

// Assign the output
assign out = count;

endmodule