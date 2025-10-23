module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg [2:0] booth_sel;
    reg [63:0] partial_products [15:0];
    reg [63:0] wallace_sum, wallace_carry;
    
    // Carry-save accumulation
    reg [63:0] acc_sum = 0, acc_carry = 0;
    
    // Early termination detection
    wire a_zero = (a == 0);
    wire b_zero = (b == 0);
    wire skip_cycle = a_zero | b_zero;
    
    // Booth encoding stage (1st pipeline stage)
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            booth_sel <= 0;
        end else if (!skip_cycle) begin
            a_reg <= a;
            b_reg <= b;
            // Simple Booth encoding (radix-4)
            booth_sel <= {b[1:0], 1'b0};
        end
    end
    
    // Partial product generation (combinational)
    always @(*) begin
        if (skip_cycle) begin
            for (int i = 0; i < 16; i++) partial_products[i] = 0;
        end else begin
            case (booth_sel)
                3'b000, 3'b111: partial_products[0] = 0;
                3'b001, 3'b010: partial_products[0] = a_reg;
                3'b011: partial_products[0] = a_reg << 1;
                3'b100: partial_products[0] = - (a_reg << 1);
                3'b101, 3'b110: partial_products[0] = -a_reg;
            endcase
            
            // Generate remaining partial products (simplified)
            for (int i = 1; i < 16; i++) begin
                partial_products[i] = partial_products[i-1] << 2;
            end
        end
    end
    
    // Wallace tree compression (2nd pipeline stage)
    always @(posedge clk) begin
        if (rst) begin
            wallace_sum <= 0;
            wallace_carry <= 0;
        end else begin
            // Simplified Wallace tree (4:2 compressor)
            wallace_sum <= partial_products[0] + partial_products[1];
            wallace_carry <= partial_products[2] + partial_products[3];
        end
    end
    
    // Carry-save accumulation
    always @(posedge clk) begin
        if (rst) begin
            acc_sum <= 0;
            acc_carry <= 0;
            c <= 0;
        end else if (!skip_cycle) begin
            // Carry-save addition
            {acc_carry, acc_sum} <= {acc_sum, acc_carry} + wallace_sum + wallace_carry;
            
            // Final addition only when needed (readout)
            c <= acc_sum[31:0] + acc_carry[31:0];
        end
    end

endmodule