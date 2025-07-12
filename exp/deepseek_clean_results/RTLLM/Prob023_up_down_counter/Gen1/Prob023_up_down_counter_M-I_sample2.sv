module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion functions
function [15:0] binary_to_gray;
    input [15:0] binary;
    binary_to_gray = binary ^ (binary >> 1);
endfunction

function [15:0] gray_to_binary;
    input [15:0] gray;
    reg [15:0] binary;
    integer i;
    begin
        binary[15] = gray[15];
        for (i = 14; i >= 0; i = i - 1)
            binary[i] = binary[i+1] ^ gray[i];
        gray_to_binary = binary;
    end
endfunction

// Internal signals
reg [15:0] binary_count;
wire [15:0] next_count;
wire count_enable = ~reset; // Enable counting when not in reset

// Carry-select adder implementation for better timing
assign next_count = up_down ? 
                   {binary_count[15:8] + (binary_count[7:0] == 8'hff), binary_count[7:0] + 1} : 
                   {binary_count[15:8] - (binary_count[7:0] == 8'h00), binary_count[7:0] - 1};

// Clock-gated process
always @(posedge clk) begin
    if (reset) begin
        binary_count <= 16'b0;
    end
    else if (count_enable) begin
        binary_count <= next_count;
    end
end

// Convert binary to Gray code for output
always @(*) begin
    count = binary_to_gray(binary_count);
end

endmodule