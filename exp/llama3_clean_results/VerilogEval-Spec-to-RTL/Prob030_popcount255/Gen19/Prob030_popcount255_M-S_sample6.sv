// Module to count the number of ones in an 8-bit segment
module SegmentCounter(
    input [7:0] in,
    output [7:0] out
);
    assign out = $countones(in);
endmodule

// Top-level module for population count
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
    wire [7:0] segment_count [31:0];

    // Instantiate SegmentCounter for each segment
    for (genvar i = 0; i < 32; i++) begin
        SegmentCounter sc(
          .in(segment[i]),
          .out(segment_count[i])
        );
    end

    // Sum the segment counts
    wire [7:0] total_count;
    assign total_count = 8'd0;
    for (genvar i = 0; i < 32; i++) begin
        assign total_count = total_count + segment_count[i];
    end

    // Assign the output
    assign out = total_count;

endmodule