module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline registers
reg [7:0] shifted_a;
reg [7:0] accumulator;
reg [1:0] bit_pos;

// State machine for bit position
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bit_pos <= 2'd0;
    end else begin
        bit_pos <= (bit_pos == 2'd3) ? 2'd0 : bit_pos + 1;
    end
end

// Stage 1: Shift multiplicand based on current bit position
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shifted_a <= 8'b0;
    end else begin
        case (bit_pos)
            2'd0: shifted_a <= {4'b0, mul_a};
            2'd1: shifted_a <= {3'b0, mul_a, 1'b0};
            2'd2: shifted_a <= {2'b0, mul_a, 2'b0};
            2'd3: shifted_a <= {1'b0, mul_a, 3'b0};
        endcase
    end
end

// Stage 2: Conditional accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        if (mul_b[bit_pos]) begin
            accumulator <= accumulator + shifted_a;
        end
        // Output complete product after processing all bits
        if (bit_pos == 2'd3) begin
            mul_out <= accumulator + (mul_b[3] ? shifted_a : 8'b0);
            accumulator <= 8'b0;  // Reset for next multiplication
        end
    end
end

endmodule