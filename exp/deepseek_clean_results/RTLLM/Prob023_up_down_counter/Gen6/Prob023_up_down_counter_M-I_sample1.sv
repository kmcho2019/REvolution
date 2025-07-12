module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
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
reg [15:0] count_reg;
wire [15:0] next_count;
wire [15:0] binary_count;
wire [15:0] binary_next;
wire count_enable;

// Clock gating: only enable when counter needs to change
assign count_enable = ~reset & (|count_reg | up_down);

// Convert Gray code to binary for arithmetic
assign binary_count = gray_to_binary(count_reg);

// Shared arithmetic logic
assign binary_next = reset ? 16'b0 : 
                    (up_down ? binary_count + 1'b1 : binary_count - 1'b1);

// Convert back to Gray code
assign next_count = binary_to_gray(binary_next);

// Pipelined implementation with clock gating
always @(posedge clk) begin
    if (reset)
        count_reg <= 16'b0;
    else if (count_enable)
        count_reg <= next_count;
end

assign count = count_reg;

endmodule