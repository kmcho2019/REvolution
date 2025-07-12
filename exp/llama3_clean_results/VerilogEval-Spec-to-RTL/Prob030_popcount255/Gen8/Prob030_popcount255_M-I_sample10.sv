module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        segment[i] = in[i*8 +: 8];
    end
end

// Population counts for each segment
wire [4:0] segment_count [31:0];

// Assign the population counts
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        segment_count[i] = $countones(segment[i]);
    end
end

// Final population count
reg [7:0] count;
integer i;

// Assign the final population count using a hierarchical approach
always @(*) begin
    count = 8'd0;
    for (i = 0; i < 32; i++) begin
        count = count + segment_count[i];
    end
end

// Assign the output
assign out = count;

endmodule