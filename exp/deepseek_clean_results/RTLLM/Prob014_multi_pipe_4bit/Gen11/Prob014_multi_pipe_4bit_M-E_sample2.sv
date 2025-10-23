module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;
localparam delay_cycles = size + 1; // 4 bits + final combine

// Pipeline control
reg [2:0] cycle_counter;
wire processing_done = (cycle_counter == delay_cycles);

// Shift register for multiplier bits
reg [3:0] b_shift;

// Accumulation registers (carry-save format)
reg [7:0] acc_sum, acc_carry;

// Partial product generation
wire [7:0] current_pp = b_shift[0] ? {4'b0, mul_a} : 8'b0;
wire [7:0] shifted_pp = {1'b0, acc_sum[7:1]}; // For right-shift accumulation

// Carry-save addition
wire [7:0] next_sum = shifted_pp ^ current_pp ^ acc_carry;
wire [7:0] next_carry = { (shifted_pp & current_pp) | 
                         (shifted_pp & acc_carry) | 
                         (current_pp & acc_carry), 1'b0 };

// Control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_counter <= 0;
        b_shift <= 0;
        acc_sum <= 0;
        acc_carry <= 0;
        mul_out <= 0;
    end else begin
        if (cycle_counter == 0) begin
            // Initialize operation
            b_shift <= mul_b;
            acc_sum <= 0;
            acc_carry <= 0;
            cycle_counter <= 1;
        end else if (!processing_done) begin
            // Pipeline processing
            b_shift <= {1'b0, b_shift[3:1]}; // Right shift
            acc_sum <= next_sum;
            acc_carry <= next_carry;
            cycle_counter <= cycle_counter + 1;
        end else begin
            // Final result combination
            mul_out <= acc_sum + acc_carry;
            cycle_counter <= 0;
        end
    end
end

endmodule