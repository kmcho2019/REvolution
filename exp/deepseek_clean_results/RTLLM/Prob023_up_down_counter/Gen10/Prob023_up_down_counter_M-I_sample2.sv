module up_down_counter (
    input clk,
    input reset,
    input up_down,
    input enable,       // Added enable signal for power optimization
    output reg [15:0] count
);

// Clock gating control
wire gated_clk;
assign gated_clk = clk & enable;

// Carry-select adder implementation (4-bit blocks)
wire [15:0] next_count;
wire [3:0] carry;

// First 4-bit block (no carry-in)
assign {carry[0], next_count[3:0]} = count[3:0] + {3'b0, up_down} + {3'b0, ~up_down};

// Middle blocks (4-bit each)
genvar i;
generate
    for (i = 4; i < 16; i = i + 4) begin : adder_blocks
        wire [3:0] block_sum;
        wire block_carry;
        
        // Carry-select implementation
        assign {block_carry, block_sum} = count[i+3:i] + {3'b0, carry[(i/4)-1]} + {3'b0, up_down} + {3'b0, ~up_down};
        
        assign next_count[i+3:i] = block_sum;
        assign carry[i/4] = block_carry;
    end
endgenerate

// Sequential logic with gated clock
always @(posedge gated_clk or posedge reset) begin
    if (reset)
        count <= 16'b0;
    else if (enable)
        count <= next_count;
end

endmodule