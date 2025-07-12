module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs with explicit parameter
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Clock gating control
wire clk_en = rst_n;  // Disable clock during reset

// Stage 1: Partial product generation using packed array
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PROD
        assign pp[i] = mul_b[i] ? (ext_a << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers (packed array implementation)
reg [2*size-1:0] stage1_regs [0:3];
reg [2*size-1:0] sum01_reg, sum23_reg;

// Stage 1: Partial product registration and first-level addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer j=0; j<4; j=j+1) begin
            stage1_regs[j] <= {2*size{1'b0}};
        end
        sum01_reg <= {2*size{1'b0}};
        sum23_reg <= {2*size{1'b0}};
    end else if (clk_en) begin
        // Register all partial products
        for (integer k=0; k<4; k=k+1) begin
            stage1_regs[k] <= pp[k];
        end
        
        // Carry-save style first level addition
        sum01_reg <= pp[0] + pp[1];
        sum23_reg <= pp[2] + pp[3];
    end
end

// Stage 2: Final accumulation with registered output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else if (clk_en) begin
        mul_out <= sum01_reg + sum23_reg;
    end
end

endmodule