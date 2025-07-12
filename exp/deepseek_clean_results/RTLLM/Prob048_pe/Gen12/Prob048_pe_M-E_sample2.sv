module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] acc_reg;
    wire signed [63:0] next_acc;
    
    // Booth encoding signals
    wire [16:0] booth_select;
    wire [15:0][31:0] partial_products;
    
    // Zero detection
    wire a_zero = (a == 32'b0);
    wire b_zero = (b == 32'b0);
    wire skip_mult = a_zero | b_zero;
    
    // Booth encoder (radix-4)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth
            wire [2:0] booth_bits = (i == 0) ? {b_reg[1], b_reg[0], 1'b0} : 
                                    {b_reg[2*i+1], b_reg[2*i], b_reg[2*i-1]};
            
            always @(*) begin
                case (booth_bits)
                    3'b000, 3'b111: partial_products[i] = 32'b0;
                    3'b001, 3'b010: partial_products[i] = a_reg;
                    3'b011:         partial_products[i] = a_reg << 1;
                    3'b100:         partial_products[i] = -(a_reg << 1);
                    3'b101, 3'b110: partial_products[i] = -a_reg;
                endcase
            end
        end
    endgenerate
    
    // Wallace tree reduction (simplified for illustration)
    wire [63:0] wallace_out;
    assign wallace_out = partial_products[0] + 
                        (partial_products[1] << 2) +
                        (partial_products[2] << 4) + 
                        // ... more levels of compression ...
                        (partial_products[15] << 30);
    
    // Carry-save accumulator
    assign next_acc = skip_mult ? acc_reg : 
                    (acc_reg + {{32{wallace_out[31]}}, wallace_out[31:0]});
    
    // Saturation logic
    wire signed [63:0] saturated_acc;
    assign saturated_acc = (next_acc > 32'sh7FFFFFFF) ? 64'sh7FFFFFFF :
                         (next_acc < -32'sh80000000) ? -64'sh80000000 :
                         next_acc;
    
    // Pipeline stages
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            acc_reg <= 64'b0;
            c <= 32'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= a;
            b_reg <= b;
            
            // Stage 2: Accumulate
            acc_reg <= saturated_acc;
            c <= saturated_acc[31:0];
        end
    end

endmodule