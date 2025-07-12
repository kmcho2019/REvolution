module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define a function to count the number of '1's in a single bit
function [7:0] count_ones;
    input [7:0] in;
    begin
        count_ones = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                     {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};
    end
endfunction

// Define a function to add two 8-bit numbers
function [7:0] add_8bit;
    input [7:0] a, b;
    begin
        add_8bit = a + b;
    end
endfunction

// Count the number of '1's in each 8-bit chunk
reg [7:0] count [31:0];
integer i;
always @(*) begin
    for (i = 0; i < 32; i = i + 1) begin
        count[i] = count_ones(in[(i * 8) +: 8]);
    end
end

// Sum up the counts from each 8-bit chunk
reg [7:0] sum;
always @(*) begin
    sum = 8'b0;
    for (i = 0; i < 32; i = i + 1) begin
        sum = add_8bit(sum, count[i]);
    end
end

// Assign the final sum to the output
assign out = sum;

endmodule