module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] b_reg;      // Multiplier shift register
reg [2*size-1:0] a_reg;    // Multiplicand register
reg [2*size-1:0] acc_reg;  // Accumulator register
reg [1:0] bit_counter;     // Tracks current bit position

// Pipeline stage 1: Shift registers
wire [2*size-1:0] shifted_a = a_reg << 1;
wire [size-1:0] shifted_b = b_reg >> 1;

// Pipeline stage 2: Conditional addition
wire [2*size-1:0] next_acc = b_reg[0] ? (acc_reg + a_reg) : acc_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= {2*size{1'b0}};
        b_reg <= {size{1'b0}};
        acc_reg <= {2*size{1'b0}};
        bit_counter <= 2'b0;
        mul_out <= {2*size{1'b0}};
    end else begin
        if (bit_counter == 0) begin
            // Load new operands
            a_reg <= {{size{1'b0}}, mul_a};
            b_reg <= mul_b;
            acc_reg <= {2*size{1'b0}};
        end else begin
            // Normal operation
            a_reg <= shifted_a;
            b_reg <= shifted_b;
        end

        // Update accumulator (stage 2)
        acc_reg <= (bit_counter == 0) ? {2*size{1'b0}} : next_acc;

        // Update bit counter
        bit_counter <= (bit_counter == size-1) ? 2'b0 : bit_counter + 1;

        // Capture final result when complete
        if (bit_counter == size-1) begin
            mul_out <= next_acc;
        end
    end
end

endmodule