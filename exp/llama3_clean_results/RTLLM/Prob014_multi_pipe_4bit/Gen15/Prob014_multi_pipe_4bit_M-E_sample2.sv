module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Registers to store partial products
reg [7:0] pp0, pp1, pp2, pp3;

// Registers for pipeline stages
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Booth encoding scheme
reg [1:0] booth_enc;

// Generate Booth-encoded multiplier bits
always @(*) begin
    case (mul_b[3:2])
        2'b00: booth_enc = 2'b00;  // +0
        2'b01: booth_enc = 2'b01;  // +1
        2'b10: booth_enc = 2'b10;  // -1
        2'b11: booth_enc = 2'b11;  // -2
    endcase
end

// Generate partial products based on Booth-encoded multiplier bits
always @(*) begin
    case (booth_enc)
        2'b00: begin
            pp0 = 8'd0;
            pp1 = 8'd0;
        end
        2'b01: begin
            pp0 = {4'b0, mul_a};
            pp1 = 8'd0;
        end
        2'b10: begin
            pp0 = {4'b0, ~mul_a + 1'b1};  // -1 * mul_a
            pp1 = 8'd0;
        end
        2'b11: begin
            pp0 = {4'b0, ~mul_a + 1'b1};  // -1 * mul_a
            pp1 = {4'b0, ~mul_a + 1'b1};  // -1 * mul_a
        end
    endcase
end

// Generate partial products for lower 2 bits of multiplier
always @(*) begin
    case (mul_b[1:0])
        2'b00: begin
            pp2 = 8'd0;
            pp3 = 8'd0;
        end
        2'b01: begin
            pp2 = ({4'b0, mul_a} << 1);
            pp3 = 8'd0;
        end
        2'b10: begin
            pp2 = ({4'b0, mul_a} << 2);
            pp3 = 8'd0;
        end
        2'b11: begin
            pp2 = ({4'b0, mul_a} << 2);
            pp3 = ({4'b0, mul_a} << 1);
        end
    endcase
end

// Pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline stages
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Add partial products
        stage1_reg <= pp0 + pp1 + pp2 + pp3;
        
        // Stage 2: Output final product
        stage2_reg <= stage1_reg;
        
        // Output the final product
        mul_out <= stage2_reg;
    end
end

endmodule