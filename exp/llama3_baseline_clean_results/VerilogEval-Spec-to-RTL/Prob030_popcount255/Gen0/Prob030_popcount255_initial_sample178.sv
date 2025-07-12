module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define a function to count the number of '1's in a byte
function [7:0] count_ones;
    input [7:0] byte;
    begin
        count_ones = {8{1'b0}};
        for (int i = 0; i < 8; i++) begin
            count_ones += byte[i];
        end
    end
endfunction

// Define a variable to hold the sum
reg [7:0] sum;

// Count the '1's in each byte and sum them up
always @(*) begin
    reg [7:0] byte_count;
    reg [7:0] partial_byte_count;
    sum = 8'd0;
    
    // Count for full bytes
    for (int i = 0; i < 31; i++) begin
        byte_count = count_ones(in[(i*8)+7:(i*8)]);
        sum += byte_count;
    end
    
    // Count for the partial byte
    partial_byte_count = 8'd0;
    for (int j = 0; j < 7; j++) begin
        partial_byte_count += in[j];
    end
    sum += partial_byte_count;
    
    out <= sum;
end

endmodule