module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Pipeline Stage 0: Input Registration
    reg [2*size-1:0] ext_a_reg, ext_b_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ext_a_reg <= 0;
            ext_b_reg <= 0;
        end else begin
            ext_a_reg <= {{size{1'b0}}, mul_a};
            ext_b_reg <= {{size{1'b0}}, mul_b};
        end
    end

    // Pipeline Stage 1: Calculate pp0 and pp1
    wire [2*size-1:0] pp0 = ext_b_reg[0] ? ext_a_reg : 0;
    wire [2*size-1:0] pp1 = ext_b_reg[1] ? (ext_a_reg << 1) : 0;
    wire [2*size-1:0] sum01 = pp0 + pp1;
    
    reg [2*size-1:0] sum01_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= 0;
        end else begin
            sum01_reg <= sum01;
        end
    end

    // Pipeline Stage 2: Calculate pp2 and pp3
    wire [2*size-1:0] pp2 = ext_b_reg[2] ? (ext_a_reg << 2) : 0;
    wire [2*size-1:0] pp3 = ext_b_reg[3] ? (ext_a_reg << 3) : 0;
    wire [2*size-1:0] sum23 = pp2 + pp3;
    
    reg [2*size-1:0] sum23_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum23_reg <= 0;
        end else begin
            sum23_reg <= sum23;
        end
    end

    // Pipeline Stage 3: Final Sum
    wire [2*size-1:0] final_sum = sum01_reg + sum23_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= final_sum;
        end
    end

endmodule