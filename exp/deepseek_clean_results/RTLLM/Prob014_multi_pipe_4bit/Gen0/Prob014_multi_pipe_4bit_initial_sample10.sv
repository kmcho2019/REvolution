module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs (size bits of zero padding)
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products
    wire [2*size-1:0] pp [size-1:0];
    
    // First pipeline stage registers
    reg [2*size-1:0] pp_reg [size-1:0];
    
    // Second pipeline stage registers
    reg [2*size-1:0] sum_reg;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline stage 1: Register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= {2*size{1'b0}};
            end
        end else begin
            for (integer j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= pp[j];
            end
        end
    end

    // Pipeline stage 2: Accumulate partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= {2*size{1'b0}};
        end else begin
            sum_reg <= pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_reg;
        end
    end

endmodule