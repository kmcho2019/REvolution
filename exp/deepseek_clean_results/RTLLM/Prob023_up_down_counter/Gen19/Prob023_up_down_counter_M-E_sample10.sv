module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parallel prefix adder implementation
wire [15:0] operand_b = up_down ? 16'h0001 : 16'hFFFF; // +1 or -1 (two's complement)
wire [15:0] sum;
wire [15:0] carry_propagate, carry_generate;
wire [15:0] carry;

// Generate propagate and generate signals
assign carry_generate = count & operand_b;
assign carry_propagate = count ^ operand_b;

// Kogge-Stone prefix tree implementation
genvar i, j;
generate
    // First level - bitwise
    for (i = 0; i < 16; i = i + 1) begin : bit_level
        if (i == 0) begin
            assign carry[i] = carry_generate[i];
        end else begin
            assign carry[i] = carry_generate[i] | (carry_propagate[i] & carry_generate[i-1]);
        end
    end

    // Subsequent levels with increasing span
    for (j = 1; j <= 3; j = j + 1) begin : prefix_levels
        for (i = 0; i < 16; i = i + 1) begin : prefix_bits
            if (i >= (1 << j)) begin
                assign carry[i] = carry[i] | (carry_propagate[i] & carry[i - (1 << j)]);
            end
        end
    end
endgenerate

// Final sum calculation
assign sum = carry_propagate ^ {1'b0, carry[14:0]};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= sum;
    end
end

endmodule