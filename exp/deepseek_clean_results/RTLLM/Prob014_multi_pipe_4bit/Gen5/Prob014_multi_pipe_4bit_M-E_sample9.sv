module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand with sign bit
    wire [size:0] a_ext = {1'b0, mul_a};
    
    // Booth encoder outputs
    wire [1:0] booth_sel [1:0];
    wire [size:0] pp [1:0];
    
    // Generate booth encoded partial products
    genvar i;
    generate
        for (i = 0; i < 2; i = i + 1) begin : booth_enc
            // Booth encoding (radix-4)
            always @(*) begin
                case (mul_b[2*i+1:2*i-1])  // overlapped 3-bit groups
                    3'b000, 3'b111: booth_sel[i] = 2'b00;  // 0
                    3'b001, 3'b010: booth_sel[i] = 2'b01;  // +1
                    3'b011:         booth_sel[i] = 2'b10;  // +2
                    3'b100:         booth_sel[i] = 2'b11;  // -2
                    3'b101, 3'b110: booth_sel[i] = 2'b11;  // -1 (encoded same as -2)
                endcase
            end
            
            // Partial product selection
            assign pp[i] = (booth_sel[i] == 2'b00) ? 0 :
                          ((booth_sel[i] == 2'b01) ? a_ext :
                          ((booth_sel[i] == 2'b10) ? {a_ext[size-1:0], 1'b0} :
                          ~{a_ext[size-1:0], 1'b0} + 1;  // Two's complement
        end
    endgenerate

    // Pipeline stage 1 registers
    reg [size:0] pp0_reg, pp1_reg;
    reg [1:0] shift0_reg, shift1_reg;
    
    // Pipeline stage 2 registers
    reg [2*size-1:0] sum_reg;
    reg [2*size-1:0] carry_reg;
    
    // Shifted partial products
    wire [2*size-1:0] pp0_shifted = {{(size-2){1'b0}}, pp0_reg, {2{1'b0}}};
    wire [2*size-1:0] pp1_shifted = {{(size){1'b0}}, pp1_reg};
    
    // Carry-save addition
    wire [2*size-1:0] stage1_sum = pp0_shifted ^ pp1_shifted;
    wire [2*size-1:0] stage1_carry = (pp0_shifted & pp1_shifted) << 1;
    
    // Final addition
    wire [2*size-1:0] final_sum = sum_reg + carry_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            pp0_reg <= 0;
            pp1_reg <= 0;
            shift0_reg <= 0;
            shift1_reg <= 0;
            sum_reg <= 0;
            carry_reg <= 0;
            mul_out <= 0;
        end else begin
            // Pipeline stage 1: register partial products
            pp0_reg <= pp[0];
            pp1_reg <= pp[1];
            shift0_reg <= 0;  // 0-bit shift for pp0 (already shifted in encoding)
            shift1_reg <= 2;  // 2-bit shift for pp1
            
            // Pipeline stage 2: register intermediate sums
            sum_reg <= stage1_sum;
            carry_reg <= stage1_carry;
            
            // Final output
            mul_out <= final_sum;
        end
    end

endmodule