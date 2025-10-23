module TopModule (
    input clk,
    input [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    reg [3:0] in_reg;
    wire [3:0] left_shifted = {in_reg[2:0], in_reg[3]}; // Circular left shift
    wire [3:0] right_shifted = {in_reg[0], in_reg[3:1]}; // Circular right shift

    always @(posedge clk) begin
        // Register input for clean timing
        in_reg <= in;

        // out_both: current bit AND left neighbor (except MSB)
        out_both <= {1'b0, in_reg[2:0] & in_reg[3:1]};

        // out_any: current bit OR right neighbor (except LSB)
        out_any <= {in_reg[3:1] | in_reg[2:0], 1'b0};

        // out_different: XOR with left neighbor (circular)
        out_different <= in_reg ^ left_shifted;
    end

endmodule