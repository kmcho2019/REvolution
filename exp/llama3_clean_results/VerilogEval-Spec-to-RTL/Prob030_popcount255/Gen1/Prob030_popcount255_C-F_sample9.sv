module TopModule(
    input [254:0] in,
    output [7:0] out
);

reg [7:0] count;

always @(*) begin
    count = 8'b0;
    reg [4:0] group_counts[7:0];
    
    // Divide the 255-bit input into 8 groups of 32 bits (except the last group which will be 31 bits)
    for (int i = 0; i < 8; i++) begin
        group_counts[i] = 5'b0;
        for (int j = 0; j < (i < 7) ? 32 : 31; j++) begin
            if (in[i*32 + j]) begin
                group_counts[i] = group_counts[i] + 1'b1;
            end
        end
    end
    
    // Use a tree-like structure of adders to sum up the group counts
    reg [5:0] temp_count;
    temp_count = group_counts[0] + group_counts[1];
    for (int i = 2; i < 8; i++) begin
        temp_count = temp_count + group_counts[i];
    end
    
    // Assign the count to the output
    count = temp_count[4:0];
end

assign out = count;

endmodule