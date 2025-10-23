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

// Clock gating during reset
wire clk_en = rst_n;

// Stage 1: Partial product generation using packed array
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PROD
        assign pp[i] = mul_b[i] ? (ext_a << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers (packed arrays)
reg [2*size-1:0] pp_reg [0:size-1];
reg [2*size-1:0] sum01_reg, sum23_reg;

// Stage 1: Register partial products and first-level CSA reduction
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer j=0; j<size; j=j+1) begin
            pp_reg[j] <= {2*size{1'b0}};
        end
        sum01_reg <= {2*size{1'b0}};
        sum23_reg <= {2*size{1'b0}};
    end else if (clk_en) begin
        // Register all partial products
        for (integer j=0; j<size; j=j+1) begin
            pp_reg[j] <= pp[j];
        end
        
        // First level carry-save addition
        sum01_reg <= pp[0] + pp[1];
        sum23_reg <= pp[2] + pp[3];
    end
end

// Stage 2: Final accumulation with enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else if (clk_en) begin
        mul_out <= sum01_reg + sum23_reg;
    end
end

endmodule