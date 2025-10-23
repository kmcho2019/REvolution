module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];
integer i;

// Assign the segments and calculate population counts
always @(*) begin
    for (i = 0; i < 32; i = i + 1) begin
        segment[i] = in[(i * 8) +: 8];
    end
end

// Final population count
reg [7:0] count;
always @(*) begin
    count = 8'd0;
    for (i = 0; i < 32; i = i + 1) begin
        count = count + $countones(segment[i]);
    end
end

// Assign the output
assign out = count;

endmodule