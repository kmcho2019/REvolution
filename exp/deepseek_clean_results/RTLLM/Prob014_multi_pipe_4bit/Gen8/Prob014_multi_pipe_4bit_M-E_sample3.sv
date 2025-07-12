module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Booth encoder outputs
wire [2:0] booth_sel;
wire [4:0] booth_a;

// Pipeline stage 1 registers
reg [4:0] pp0, pp1, pp2;
reg [4:0] a_reg;
reg [2:0] sel_reg;

// Booth encoding (reduces 4 partial products to 3)
assign booth_sel[0] = mul_b[0] ^ mul_b[1];
assign booth_sel[1] = mul_b[1] ^ mul_b[2];
assign booth_sel[2] = mul_b[2] ^ mul_b[3];
assign booth_a = {mul_a[3], mul_a}; // Sign extended

// Stage 1: Partial product generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 5'b0;
        pp1 <= 5'b0;
        pp2 <= 5'b0;
        a_reg <= 5'b0;
        sel_reg <= 3'b0;
    end else begin
        // Generate partial products
        case ({mul_b[1:0], 1'b0})
            3'b000, 3'b111: pp0 <= 5'b0;
            3'b001, 3'b010: pp0 <= booth_a;
            3'b011:         pp0 <= booth_a << 1;
            3'b100:         pp0 <= ~(booth_a << 1) + 1;
            default:        pp0 <= ~booth_a + 1;
        endcase
        
        case (mul_b[3:1])
            3'b000, 3'b111: pp1 <= 5'b0;
            3'b001, 3'b010: pp1 <= booth_a;
            3'b011:         pp1 <= booth_a << 1;
            3'b100:         pp1 <= ~(booth_a << 1) + 1;
            default:        pp1 <= ~booth_a + 1;
        endcase
        
        pp2 <= (mul_b[3] & ~mul_b[2]) ? (~booth_a + 1) : 5'b0;
        
        // Pipeline registers
        a_reg <= booth_a;
        sel_reg <= booth_sel;
    end
end

// Stage 2: Parallel prefix adder (Kogge-Stone)
wire [7:0] sum;

// Generate and propagate
wire [7:0] g = {3'b0, pp2, 1'b0} & {3'b0, pp1, 1'b0};
wire [7:0] p = {3'b0, pp2, 1'b0} ^ {3'b0, pp1, 1'b0};

// Prefix computation
wire [7:0] g1, p1;
wire [7:0] g2, p2;

assign g1 = g | (p & {1'b0, g[7:1]});
assign p1 = p & {1'b0, p[7:1]};

assign g2 = g1 | (p1 & {2'b0, g1[7:2]});
assign p2 = p1 & {2'b0, p1[7:2]};

// Final sum computation
assign sum = {3'b0, pp0, 1'b0} ^ {g2[6:0], 1'b0} ^ {p2[6:0], 1'b0};

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum;
    end
end

endmodule