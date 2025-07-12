module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 chunks of 8 bits (except the last chunk which is 7 bits)
wire [7:0] chunk [31:0];

// Assign the chunks
genvar i;
generate
    for (i = 0; i < 31; i++) begin
        assign chunk[i] = in[(i*8)+7:i*8];
    end
    assign chunk[31] = {1'b0, in[254:248]};
endgenerate

// Compute population count for each chunk using bitwise operations
wire [4:0] chunk_count [31:0];

// Function to count ones in an 8-bit vector
function [4:0] count_ones;
    input [7:0] vec;
    reg [4:0] count;
    begin
        count = 0;
        for (int i = 0; i < 8; i++) begin
            if (vec[i]) begin
                count = count + 1;
            end
        end
        count_ones = count;
    end
endfunction

generate
    for (genvar j = 0; j < 32; j++) begin
        assign chunk_count[j] = count_ones(chunk[j]);
    end
endgenerate

// First level of adder tree: sum counts in pairs
wire [5:0] level1_count [15:0];

generate
    for (genvar k = 0; k < 16; k++) begin
        if (k < 15) begin
            assign level1_count[k] = chunk_count[k*2] + chunk_count[k*2+1];
        end else begin
            assign level1_count[k] = chunk_count[k*2];
        end
    end
endgenerate

// Second level of adder tree: sum counts in pairs again
wire [6:0] level2_count [7:0];

generate
    for (genvar l = 0; l < 8; l++) begin
        if (l < 7) begin
            assign level2_count[l] = level1_count[l*2] + level1_count[l*2+1];
        end else begin
            assign level2_count[l] = level1_count[l*2];
        end
    end
endgenerate

// Third level of adder tree: sum counts in pairs one last time
wire [7:0] level3_count [3:0];

generate
    for (genvar m = 0; m < 4; m++) begin
        if (m < 3) begin
            assign level3_count[m] = level2_count[m*2] + level2_count[m*2+1];
        end else begin
            assign level3_count[m] = level2_count[m*2];
        end
    end
endgenerate

// Final level: sum the last counts
wire [7:0] final_count;
assign final_count = level3_count[0] + level3_count[1] + level3_count[2] + level3_count[3];

// Assign the output
assign out = final_count;

endmodule