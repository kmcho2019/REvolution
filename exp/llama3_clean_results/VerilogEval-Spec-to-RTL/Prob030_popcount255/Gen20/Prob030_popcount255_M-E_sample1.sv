// Module to compute population count for an 8-bit slice
module SlicePopulationCount(
    input [7:0] in,
    output [7:0] out
);
    // Simple combinational circuit to count '1's in an 8-bit vector
    assign out = {8{1'b0}} + 
                 (in[0]? 8'b00000001 : 8'b00000000) + 
                 (in[1]? 8'b00000001 : 8'b00000000) + 
                 (in[2]? 8'b00000001 : 8'b00000000) + 
                 (in[3]? 8'b00000001 : 8'b00000000) + 
                 (in[4]? 8'b00000001 : 8'b00000000) + 
                 (in[5]? 8'b00000001 : 8'b00000000) + 
                 (in[6]? 8'b00000001 : 8'b00000000) + 
                 (in[7]? 8'b00000001 : 8'b00000000);
endmodule

// Module to compute prefix sum of population counts
module PrefixSum(
    input [7:0] a,
    input [7:0] b,
    output [8:0] out
);
    assign out = a + b;
endmodule

// Top-level module for population count
module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into 32 slices of 8 bits
    wire [7:0] slice [31:0];

    // Assign the slices
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign slice[i] = {1'b0, in[254:248]};
        end else begin
            assign slice[i] = in[(i*8)+7:i*8];
        end
    end

    // Population counts for each slice
    wire [7:0] slice_count [31:0];

    // Instantiate SlicePopulationCount for each slice
    for (genvar i = 0; i < 32; i++) begin
        SlicePopulationCount spc(
         .in(slice[i]),
         .out(slice_count[i])
        );
    end

    // Prefix sum calculation
    wire [8:0] prefix_sum [31:0];
    assign prefix_sum[0] = {1'b0, slice_count[0]};
    for (genvar i = 1; i < 32; i++) begin
        PrefixSum ps(
         .a(prefix_sum[i-1]),
         .b(slice_count[i]),
         .out(prefix_sum[i])
        );
    end

    // Final population count
    assign out = prefix_sum[31][7:0];

endmodule