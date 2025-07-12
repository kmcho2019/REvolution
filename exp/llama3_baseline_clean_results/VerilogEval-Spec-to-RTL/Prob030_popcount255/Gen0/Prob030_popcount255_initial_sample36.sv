module TopModule(
    input [254:0] in, 
    output [7:0] out
);

// Function to count the number of '1's in a 16-bit vector
function [4:0] pop_count_16;
    input [15:0] vec;
    reg [4:0] count;
    begin
        count = 0;
        for (int i = 0; i < 16; i++) begin
            if (vec[i]) begin
                count = count + 1;
            end
        end
        pop_count_16 = count;
    end
endfunction

// Function to count the number of '1's in a 255-bit vector
function [7:0] pop_count_255;
    input [254:0] vec;
    reg [4:0] count_16 [15:0];
    reg [7:0] count;
    begin
        // Divide the 255-bit vector into 16 16-bit groups
        // (with the last group having only 7 bits)
        for (int i = 0; i < 15; i++) begin
            count_16[i] = pop_count_16(vec[(i*16)+:16]);
        end
        count_16[15] = pop_count_16({8'd0, vec[254:247]}); // Count '1's in the last 7 bits

        // Combine the counts from each group
        count = 0;
        for (int i = 0; i < 16; i++) begin
            count = count + count_16[i];
        end

        // Return the total count
        pop_count_255 = count;
    end
endfunction

assign out = pop_count_255(in);

endmodule