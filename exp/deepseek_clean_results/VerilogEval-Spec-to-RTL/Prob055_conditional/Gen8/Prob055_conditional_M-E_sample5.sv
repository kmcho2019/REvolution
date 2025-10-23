module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        reg [7:0] candidates [0:3];
        integer i, j, count;
        reg [7:0] temp_min;
        
        // Initialize candidates
        candidates[0] = a;
        candidates[1] = b;
        candidates[2] = c;
        candidates[3] = d;
        count = 4;
        
        // Priority encoder style minimum finder
        for (i = 7; i >= 0; i = i - 1) begin
            if (count == 1) break; // Early exit if only one candidate
            
            // Count how many candidates have 0 in current bit
            integer zeros = 0;
            for (j = 0; j < count; j = j + 1) begin
                if (candidates[j][i] == 1'b0) zeros = zeros + 1;
            end
            
            // If any zeros exist, keep only those candidates
            if (zeros > 0) begin
                integer new_count = 0;
                for (j = 0; j < count; j = j + 1) begin
                    if (candidates[j][i] == 1'b0) begin
                        candidates[new_count] = candidates[j];
                        new_count = new_count + 1;
                    end
                end
                count = new_count;
            end
        end
        
        // Final minimum is first remaining candidate
        min = candidates[0];
    end

endmodule