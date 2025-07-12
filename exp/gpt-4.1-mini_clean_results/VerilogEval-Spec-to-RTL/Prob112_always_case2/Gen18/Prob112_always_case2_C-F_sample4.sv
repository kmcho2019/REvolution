module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

wire n0, n1, n2;
wire [3:0] masked;

// Shared inverted inputs to reduce redundant logic and switching
assign n0 = ~in[0];
assign n1 = ~in[1];
assign n2 = ~in[2];

// Generate masked one-hot vector where only the highest priority set bit remains
assign masked[0] = in[0];
assign masked[1] = in[1] & n0;
assign masked[2] = in[2] & n1 & n0;
assign masked[3] = in[3] & n2 & n1 & n0;

// Function to convert one-hot masked vector to position
function [1:0] masked_to_pos;
    input [3:0] msk;
    begin
        case (msk)
            4'b0001: masked_to_pos = 2'd0;
            4'b0010: masked_to_pos = 2'd1;
            4'b0100: masked_to_pos = 2'd2;
            4'b1000: masked_to_pos = 2'd3;
            default: masked_to_pos = 2'd0; // No bits set
        endcase
    end
endfunction

// Continuous assignment to output position with minimal logic and glitch potential
always @(*) begin
    pos = masked_to_pos(masked);
end

endmodule