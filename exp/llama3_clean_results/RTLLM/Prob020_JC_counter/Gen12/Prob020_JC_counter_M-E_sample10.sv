// Module JC_bit: 1-bit Johnson counter module
module JC_bit(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    input [1:0] prev_bit, // Previous bit (2 bits for current and next state)
    output reg [1:0] Q // Current and next bit values
);

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the bit to 0
        Q <= 2'd0;
    end else begin
        // Normal operation: Determine next bit based on current bit
        if (prev_bit[0] == 1'b0) begin
            // If previous bit is 0, set next bit to 1
            Q <= {1'b1, prev_bit[1]};
        end else begin
            // If previous bit is 1, set next bit to 0
            Q <= {1'b0, prev_bit[1]};
        end
    end
end

endmodule

// Module JC_counter: 64-bit Johnson counter using JC_bit modules
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Instantiate 64 JC_bit modules in a chain
wire [1:0] bit_out [63:0];
reg [63:0] bit_Q;

// Always block to assign final Q
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        bit_Q <= 64'd0;
    end else begin
        bit_Q <= bit_out[63][1];
        for (int i = 63; i > 0; i--) begin
            bit_Q[i-1] <= bit_out[i-1][1];
        end
    end
end

// Generate 64 JC_bit modules
genvar i;
generate
    for (i = 0; i < 64; i++) begin: bit_gen
        if (i == 0) begin
            // For the first bit, use the current state directly
            JC_bit bit_inst (
                .clk(clk),
                .rst_n(rst_n),
                .prev_bit({1'b0, bit_Q[i]}),
                .Q(bit_out[i])
            );
        end else begin
            // For subsequent bits, use the previous bit's output
            JC_bit bit_inst (
                .clk(clk),
                .rst_n(rst_n),
                .prev_bit(bit_out[i-1]),
                .Q(bit_out[i])
            );
        end
    end
endgenerate

assign Q = bit_Q;

endmodule