module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline control registers
    reg [2:0] stage_cnt;
    reg processing;
    
    // Operand registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    
    // Carry-save accumulator
    reg [15:0] sum;
    reg [15:0] carry;
    
    // Early termination detection
    wire zero_multiplier = (multiplier == 8'b0);
    
    // Barrel shifter for multiplicand
    wire [15:0] shifted_a = {8'b0, multiplicand} << stage_cnt;
    
    // Bit-serial processing logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage_cnt <= 3'b0;
            processing <= 1'b0;
            multiplicand <= 8'b0;
            multiplier <= 8'b0;
            sum <= 16'b0;
            carry <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Pipeline stage 1: Input capture
            if (mul_en_in && !processing) begin
                multiplicand <= mul_a;
                multiplier <= mul_b;
                sum <= 16'b0;
                carry <= 16'b0;
                processing <= 1'b1;
                stage_cnt <= 3'b0;
            end
            
            // Pipeline stage 2: Bit-serial processing
            if (processing) begin
                if (zero_multiplier) begin
                    // Early termination
                    processing <= 1'b0;
                    mul_en_out <= 1'b1;
                    mul_out <= sum + carry;
                end else if (stage_cnt == 3'd7) begin
                    // Final stage
                    processing <= 1'b0;
                    mul_en_out <= 1'b1;
                    mul_out <= sum + carry;
                end else begin
                    // Process current bit
                    if (multiplier[0]) begin
                        {carry, sum} <= {1'b0, sum} + {1'b0, shifted_a} + {carry, 1'b0};
                    end
                    multiplier <= multiplier >> 1;
                    stage_cnt <= stage_cnt + 1;
                end
            end else begin
                mul_en_out <= 1'b0;
            end
        end
    end

endmodule