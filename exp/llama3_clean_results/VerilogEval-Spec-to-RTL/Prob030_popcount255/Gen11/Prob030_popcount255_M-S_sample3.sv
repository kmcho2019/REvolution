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
reg [7:0] segment_count [31:0];

// Calculate population count for each segment
always @(*) begin
    for (int i = 0; i < 32; i++) begin
        segment_count[i] = 0;
        for (int j = 0; j < 8; j++) begin
            if (segment[i][j] == 1'b1) begin
                segment_count[i] = segment_count[i] + 1;
            end
        end
    end
end

// Final population count
reg [7:0] count;

// Calculate final population count
always @(*) begin
    count = 0;
    for (int i = 0; i < 32; i++) begin
        count = count + segment_count[i];
    end
    if (count > 8'hFF) begin
        count = 8'hFF;
    end
end

// Assign the output
assign out = count;

endmodule