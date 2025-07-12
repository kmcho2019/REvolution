module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Registered inputs
reg [size-1:0] a_reg, b_reg;

// Partial products (extended to 2*size bits)
wire [2*size-1:0] pp [0:size-1];

// Pipeline registers
reg [2*size-1:0] sum01, sum23;
reg [2*size-1:0] sum_final;

// Generate all partial products
generate
    genvar i;
    for (i = 0; i < size; i = i + 1) begin : pp_gen
        assign pp[i] = b_reg[i] ? ({ {size{1'b0}}, a_reg } << i) : {2*size{1'b0}};
    end
endgenerate

// Stage 0: Register inputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= {size{1'b0}};
        b_reg <= {size{1'b0}};
    end else begin
        a_reg <= mul_a;
        b_reg <= mul_b;
    end
end

// Stage 1: First level of addition (pipelined)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum01 <= {2*size{1'b0}};
        sum23 <= {2*size{1'b0}};
    end else begin
        sum01 <= pp[0] + pp[1];
        sum23 <= pp[2] + pp[3];
    end
end

// Stage 2: Final addition and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_final <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        sum_final <= sum01 + sum23;
        mul_out <= sum_final;
    end
end

endmodule