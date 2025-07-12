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

    // Calculate population count for each segment
    for (genvar i = 0; i < 32; i++) begin
        assign segment_count[i] = $countones(segment[i]);
    end

    // Sum the segment counts using a more efficient method
    wire [10:0] sum_count;
    assign sum_count = {3'b0, segment_count[0]} + 
                       {3'b0, segment_count[1]} + 
                       {3'b0, segment_count[2]} + 
                       {3'b0, segment_count[3]} + 
                       {3'b0, segment_count[4]} + 
                       {3'b0, segment_count[5]} + 
                       {3'b0, segment_count[6]} + 
                       {3'b0, segment_count[7]} + 
                       {3'b0, segment_count[8]} + 
                       {3'b0, segment_count[9]} + 
                       {3'b0, segment_count[10]} + 
                       {3'b0, segment_count[11]} + 
                       {3'b0, segment_count[12]} + 
                       {3'b0, segment_count[13]} + 
                       {3'b0, segment_count[14]} + 
                       {3'b0, segment_count[15]} + 
                       {3'b0, segment_count[16]} + 
                       {3'b0, segment_count[17]} + 
                       {3'b0, segment_count[18]} + 
                       {3'b0, segment_count[19]} + 
                       {3'b0, segment_count[20]} + 
                       {3'b0, segment_count[21]} + 
                       {3'b0, segment_count[22]} + 
                       {3'b0, segment_count[23]} + 
                       {3'b0, segment_count[24]} + 
                       {3'b0, segment_count[25]} + 
                       {3'b0, segment_count[26]} + 
                       {3'b0, segment_count[27]} + 
                       {3'b0, segment_count[28]} + 
                       {3'b0, segment_count[29]} + 
                       {3'b0, segment_count[30]} + 
                       {3'b0, segment_count[31]};

    // Final population count
    assign out = sum_count[7:0];

endmodule