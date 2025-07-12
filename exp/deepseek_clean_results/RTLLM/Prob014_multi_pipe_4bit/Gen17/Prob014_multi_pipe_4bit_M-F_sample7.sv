module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [size-1:0] a_reg;
reg [size-1:0] b_reg;
reg [2*size-1:0] pp_acc [0:3];
reg [2*size-1:0] ext_a_reg [0:3];

// Extended multiplicand
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_reg <= 0;
        b_reg <= 0;
        for (integer i = 0; i < 4; i = i + 1) begin
            pp_acc[i] <= 0;
            ext_a_reg[i] <= 0;
        end
        mul_out <= 0;
    end else begin
        // Stage 0: Register inputs and extended multiplicand
        a_reg <= mul_a;
        b_reg <= mul_b;
        ext_a_reg[0] <= ext_a;
        
        // Stage 1: Process bit 0
        ext_a_reg[1] <= ext_a_reg[0];
        pp_acc[0] <= b_reg[0] ? ext_a_reg[0] : 0;
        
        // Stage 2: Process bit 1
        ext_a_reg[2] <= ext_a_reg[1];
        pp_acc[1] <= pp_acc[0] + (b_reg[1] ? (ext_a_reg[1] << 1) : 0);
        
        // Stage 3: Process bit 2
        ext_a_reg[3] <= ext_a_reg[2];
        pp_acc[2] <= pp_acc[1] + (b_reg[2] ? (ext_a_reg[2] << 2) : 0);
        
        // Final output: Process bit 3
        pp_acc[3] <= pp_acc[2] + (b_reg[3] ? (ext_a_reg[3] << 3) : 0);
        mul_out <= pp_acc[3];
    end
end

endmodule