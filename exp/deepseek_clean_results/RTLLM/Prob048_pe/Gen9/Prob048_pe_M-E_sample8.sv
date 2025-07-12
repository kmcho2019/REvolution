module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] sum_reg, carry_reg;
    
    // Booth encoded partial products
    wire signed [63:0] booth_pp [15:0];
    wire signed [63:0] sum, carry;
    
    // Generate Booth partial products (Radix-4)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth_encoder
            wire [2:0] booth_sel = {b_reg[2*i+1], b_reg[2*i], (i == 0) ? 1'b0 : b_reg[2*i-1]};
            always @(*) begin
                case (booth_sel)
                    3'b000, 3'b111: booth_pp[i] = 64'b0;
                    3'b001, 3'b010: booth_pp[i] = {{32{a_reg[31]}}, a_reg} << (2*i);
                    3'b011:        booth_pp[i] = {{31{a_reg[31]}}, a_reg, 1'b0} << (2*i);
                    3'b100:        booth_pp[i] = -{{31{a_reg[31]}}, a_reg, 1'b0} << (2*i);
                    3'b101, 3'b110: booth_pp[i] = -{{32{a_reg[31]}}, a_reg} << (2*i);
                endcase
            end
        end
    endgenerate
    
    // Carry-save adder tree
    assign sum = booth_pp[0] + booth_pp[1] + booth_pp[2] + booth_pp[3] +
                 booth_pp[4] + booth_pp[5] + booth_pp[6] + booth_pp[7] +
                 booth_pp[8] + booth_pp[9] + booth_pp[10] + booth_pp[11] +
                 booth_pp[12] + booth_pp[13] + booth_pp[14] + booth_pp[15];
    
    // Pipeline stage 1: Register inputs and compute partial products
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            // Keep sum and carry separate for carry-save accumulation
            product_reg <= sum;
        end
    end
    
    // Pipeline stage 2: Accumulation with carry-save
    always @(posedge clk) begin
        if (rst) begin
            sum_reg <= 32'b0;
            carry_reg <= 32'b0;
            c <= 32'b0;
        end else begin
            // Carry-save accumulation
            {carry_reg, sum_reg} <= {sum_reg, 1'b0} + carry_reg + product_reg[31:0];
            
            // Final binary result (only lower 32 bits)
            c <= sum_reg + carry_reg;
        end
    end

endmodule