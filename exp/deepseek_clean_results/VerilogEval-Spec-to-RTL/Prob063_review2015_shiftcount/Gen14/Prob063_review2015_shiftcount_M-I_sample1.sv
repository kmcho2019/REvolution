module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire clk_gated = clk & clk_enable;

// Gray code conversion functions
function [3:0] binary_to_gray;
    input [3:0] b;
    binary_to_gray = b ^ (b >> 1);
endfunction

function [3:0] gray_to_binary;
    input [3:0] g;
    gray_to_binary = {g[3], 
                     g[3] ^ g[2],
                     g[3] ^ g[2] ^ g[1],
                     g[3] ^ g[2] ^ g[1] ^ g[0]};
endfunction

// Shift operation
always @(posedge clk_gated) begin
    if (shift_ena) begin
        q <= {q[2:0], data};
    end
end

// Count operation with Gray code
reg [3:0] binary_count;
always @(posedge clk_gated) begin
    if (count_ena) begin
        binary_count <= gray_to_binary(q) - 1'b1;
        q <= binary_to_gray(binary_count);
    end
end

endmodule