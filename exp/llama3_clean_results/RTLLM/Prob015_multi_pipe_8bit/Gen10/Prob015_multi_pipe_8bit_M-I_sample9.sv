module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Internal registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [2:0] count; // Counter for multiplier bits
reg mul_en_out_reg; // Output enable register
reg [15:0] partial_sum_reg; // Intermediate sum register

// State machine states
reg [1:0] state; // Using reg instead of enum for Verilog compatibility
reg [1:0] next_state;

// Define state values
localparam IDLE = 2'b00;
localparam MULTIPLY = 2'b01;
localparam DONE = 2'b10;

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
            default: next_state <= IDLE;
        endcase
    end
end

// Output assignments
always @(*) begin
    mul_en_out = mul_en_out_reg;
    mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;
end

endmodule