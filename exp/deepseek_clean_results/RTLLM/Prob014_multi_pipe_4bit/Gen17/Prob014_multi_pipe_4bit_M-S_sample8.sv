module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] acc_reg [0:3];
reg [size-1:0] a_reg;
reg [size-1:0] b_reg;

// Extended multiplicand
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 0;
        b_reg <= 0;
        for (integer i = 0; i < 4; i = i + 1) begin
            acc_reg[i] <= 0;
        end
        mul_out <= 0;
    end else begin
        // Stage 0: Register inputs and initialize
        a_reg <= mul_a;
        b_reg <= mul_b;
        acc_reg[0] <= 0;
        
        // Stage 1: Process bit 0
        acc_reg[1] <= b_reg[0] ? ext_a : 0;
        
        // Stage 2: Process bit 1
        acc_reg[2] <= acc_reg[1] + (b_reg[1] ? (ext_a << 1) : 0);
        
        // Stage 3: Process bit 2
        acc_reg[3] <= acc_reg[2] + (b_reg[2] ? (ext_a << 2) : 0);
        
        // Final output: Process bit 3
        mul_out <= acc_reg[3] + (b_reg[3] ? (ext_a << 3) : 0);
    end
end

endmodule