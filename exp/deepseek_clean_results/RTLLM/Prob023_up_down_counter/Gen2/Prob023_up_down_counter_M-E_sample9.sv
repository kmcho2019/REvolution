module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

// Internal gray-coded counter
reg [15:0] gray_count;
wire [15:0] binary_count;
wire [15:0] next_binary;

// Convert gray to binary for arithmetic operations
assign binary_count[15] = gray_count[15];
genvar i;
generate
    for (i = 14; i >= 0; i = i - 1) begin : gray2bin
        assign binary_count[i] = binary_count[i+1] ^ gray_count[i];
    end
endgenerate

// Parallel prefix adder for next value calculation
wire [15:0] operand = up_down ? 16'h0001 : 16'hFFFF;
wire [15:0] gen = binary_count & operand;
wire [15:0] prop = binary_count ^ operand;
wire [15:0] carry;

// Kogge-Stone carry computation
assign carry[0] = gen[0];
assign carry[1] = gen[1] | (prop[1] & gen[0]);

generate
    for (i = 2; i < 16; i = i + 1) begin : carry_chain
        wire [i-1:0] prop_chain;
        assign prop_chain[0] = prop[i];
        for (j = 1; j < i; j = j + 1) begin
            assign prop_chain[j] = prop_chain[j-1] & prop[i-j];
        end
        assign carry[i] = gen[i] | (prop_chain[i-1] & gen[0]);
    end
endgenerate

assign next_binary = prop ^ {carry[14:0], 1'b0};

// Convert back to gray code
wire [15:0] next_gray;
assign next_gray[15] = next_binary[15];
generate
    for (i = 14; i >= 0; i = i - 1) begin : bin2gray
        assign next_gray[i] = next_binary[i+1] ^ next_binary[i];
    end
endgenerate

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        gray_count <= 16'b0;
    end else begin
        gray_count <= next_gray;
    end
end

// Final binary output (optional - could output gray code directly)
assign count = binary_count;

endmodule