module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam ext_size = 2*size;

    // Extended versions of inputs
    wire [ext_size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [ext_size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Pipeline Stage 1: First two partial products
    reg [ext_size-1:0] sum01_reg;
    wire [ext_size-1:0] pp0 = ext_b[0] ? ext_a : {ext_size{1'b0}};
    wire [ext_size-1:0] pp1 = ext_b[1] ? (ext_a << 1) : {ext_size{1'b0}};
    wire [ext_size-1:0] sum01 = pp0 + pp1;

    // Pipeline Stage 2: Next partial product and intermediate sum
    reg [ext_size-1:0] sum012_reg;
    wire [ext_size-1:0] pp2 = ext_b[2] ? (ext_a << 2) : {ext_size{1'b0}};
    wire [ext_size-1:0] sum012 = sum01_reg + pp2;

    // Pipeline Stage 3: Final partial product and result
    wire [ext_size-1:0] pp3 = ext_b[3] ? (ext_a << 3) : {ext_size{1'b0}};
    wire [ext_size-1:0] sum_final = sum012_reg + pp3;

    // Pipeline registers with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            sum01_reg <= {ext_size{1'b0}};
            sum012_reg <= {ext_size{1'b0}};
            mul_out <= {ext_size{1'b0}};
        end else begin
            // Stage 1 result
            sum01_reg <= sum01;
            
            // Stage 2 result
            sum012_reg <= sum012;
            
            // Final output
            mul_out <= sum_final;
        end
    end

endmodule