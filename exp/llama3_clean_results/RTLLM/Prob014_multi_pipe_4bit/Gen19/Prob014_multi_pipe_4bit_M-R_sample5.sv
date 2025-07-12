module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// State machine states
enum logic [1:0] {IDLE, MULTIPLY, DONE} state, next_state;

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Local variables
reg [3:0] multiplier;
reg [7:0] product;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset state machine and registers
        state <= IDLE;
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
        product <= 8'd0;
        multiplier <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                // Initialize multiplier and product
                multiplier <= mul_b;
                product <= 8'd0;
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                // Multiply and accumulate
                if (multiplier[0] == 1'b1) begin
                    product <= product + {4'b0, mul_a};
                end
                // Shift multiplicand for next iteration
                mul_a <= mul_a << 1;
                // Update multiplier for next iteration
                multiplier <= multiplier >> 1;
                // Check if multiplication is complete
                if (multiplier == 4'd0) begin
                    state <= DONE;
                end
            end
            DONE: begin
                // Output final product
                mul_out <= product;
                state <= IDLE;
            end
        endcase
    end
end

endmodule