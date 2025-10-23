module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Stage 1: Partial product generation
wire [2*size-1:0] pp [size-1:0];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PROD
        assign pp[i] = mul_b[i] ? (ext_a << i) : {2*size{1'b0}};
    end
endgenerate

// Stage 1 registers
reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
reg [2*size-1:0] sum01_reg, sum23_reg;

// Stage 1: Register partial products and compute first level sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0_reg <= {2*size{1'b0}};
        pp1_reg <= {2*size{1'b0}};
        pp2_reg <= {2*size{1'b0}};
        pp3_reg <= {2*size{1'b0}};
        sum01_reg <= {2*size{1'b0}};
        sum23_reg <= {2*size{1'b0}};
    end else begin
        // Register all partial products
        pp0_reg <= pp[0];
        pp1_reg <= pp[1];
        pp2_reg <= pp[2];
        pp3_reg <= pp[3];
        
        // First level of reduction
        sum01_reg <= pp[0] + pp[1];
        sum23_reg <= pp[2] + pp[3];
    end
end

// Stage 2: Final accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= sum01_reg + sum23_reg;
    end
end

endmodule