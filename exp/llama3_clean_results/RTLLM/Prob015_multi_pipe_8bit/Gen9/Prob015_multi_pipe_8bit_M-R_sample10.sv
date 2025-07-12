module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Internal registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [2:0] count; // Counter for multiplier bits
reg mul_en_out_reg; // Output enable register
reg [15:0] partial_sum_reg; // Intermediate sum register

// State machine states
enum logic [1:0] {IDLE, MULTIPLY, DONE} state, next_state;

// Always block for sequential logic
always @(posedge clk) begin
    if (~rst_n) begin
        // Reset all registers on low reset
        state <= IDLE;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        partial_sum_reg <= 16'b0;
        count <= 3'b000;
        mul_en_out_reg <= 1'b0;
    end else begin
        // State machine
        state <= next_state;
        case (state)
            IDLE: begin
                if (mul_en_in) begin
                    // Load inputs and start multiplication
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    count <= 3'b000;
                    partial_sum_reg <= 16'b0;
                    mul_en_out_reg <= 1'b1;
                    next_state <= MULTIPLY;
                end else begin
                    next_state <= IDLE;
                end
            end
            MULTIPLY: begin
                if (count < 8) begin
                    // Generate partial product and accumulate
                    if (mul_b_reg[count]) begin
                        partial_sum_reg <= partial_sum_reg + (mul_a_reg << count);
                    end
                    count <= count + 1'b1;
                    next_state <= MULTIPLY;
                end else begin
                    // Multiply done, store result
                    mul_out_reg <= partial_sum_reg;
                    next_state <= DONE;
                end
            end
            DONE: begin
                // Output result and reset
                mul_en_out_reg <= 1'b0;
                next_state <= IDLE;
            end
        endcase
    end
end

// Output assignments
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule