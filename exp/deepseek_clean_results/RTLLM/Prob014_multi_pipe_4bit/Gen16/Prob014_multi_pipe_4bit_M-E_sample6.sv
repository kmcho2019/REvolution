module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] accum_reg;
reg [size-1:0] shift_reg;
reg [2:0] bit_counter;
reg processing;

// Internal signals
wire [2*size-1:0] shifted_value = {shift_reg, {size{1'b0}}};
wire last_bit = (bit_counter == size-1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        accum_reg <= {2*size{1'b0}};
        shift_reg <= {size{1'b0}};
        bit_counter <= 3'b0;
        mul_out <= {2*size{1'b0}};
        processing <= 1'b0;
    end else begin
        if (!processing) begin
            // Start new multiplication
            if (|mul_b) begin  // Only start if multiplier is non-zero
                shift_reg <= mul_a;
                accum_reg <= mul_b[0] ? {{size{1'b0}}, mul_a} : {2*size{1'b0}};
                bit_counter <= 3'b1;
                processing <= 1'b1;
            end
        end else begin
            // Continue processing bits
            shift_reg <= shift_reg << 1;
            
            if (mul_b[bit_counter]) begin
                accum_reg <= accum_reg + shifted_value;
            end
            
            if (last_bit) begin
                // Final result available next cycle
                mul_out <= accum_reg + (mul_b[bit_counter] ? shifted_value : {2*size{1'b0}});
                processing <= 1'b0;
                bit_counter <= 3'b0;
            end else begin
                bit_counter <= bit_counter + 1;
            end
        end
    end
end

endmodule