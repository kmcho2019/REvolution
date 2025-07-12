module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline control signals
reg [1:0] phase;
reg [2:0] bit_counter;
reg done;

// Extended operands
reg [7:0] a_ext;
reg [3:0] b_reg;

// Carry-save registers
reg [7:0] sum_reg;
reg [7:0] carry_reg;

// Next state signals
wire [7:0] next_sum;
wire [7:0] next_carry;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        phase <= 2'b00;
        bit_counter <= 3'b0;
        done <= 1'b0;
        a_ext <= 8'b0;
        b_reg <= 4'b0;
        sum_reg <= 8'b0;
        carry_reg <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        case (phase)
            2'b00: begin // Load phase
                a_ext <= {4'b0, mul_a};
                b_reg <= mul_b;
                sum_reg <= 8'b0;
                carry_reg <= 8'b0;
                bit_counter <= 3'b0;
                done <= 1'b0;
                phase <= 2'b01;
            end
            
            2'b01: begin // Shift phase
                if (b_reg[bit_counter]) begin
                    // Prepare shifted multiplicand
                    a_ext <= a_ext << bit_counter;
                    phase <= 2'b10;
                end else if (bit_counter == size-1) begin
                    // Early termination if no more 1s
                    phase <= 2'b11;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
            
            2'b10: begin // Accumulate phase
                // Carry-save addition
                {next_carry, next_sum} = sum_reg + carry_reg + a_ext;
                sum_reg <= next_sum;
                carry_reg <= next_carry << 1;
                
                if (bit_counter == size-1) begin
                    phase <= 2'b11;
                end else begin
                    bit_counter <= bit_counter + 1;
                    phase <= 2'b01;
                end
            end
            
            2'b11: begin // Final addition
                mul_out <= sum_reg + carry_reg;
                done <= 1'b1;
                phase <= 2'b00;
            end
        endcase
    end
end

endmodule