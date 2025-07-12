module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand (only mul_a needs extension)
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// Partial products
wire [2*size-1:0] pp [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign pp[i] = mul_b[i] ? (a_ext << i) : 0;
    end
endgenerate

// Pipeline Stage 1 Registers
reg [2*size-1:0] sum01, sum23;

// Pipeline Stage 2 Register
reg [2*size-1:0] final_sum;

always @(posedge clk) begin
    if (!rst_n) begin
        sum01 <= 0;
        sum23 <= 0;
        final_sum <= 0;
        mul_out <= 0;
    end else begin
        // First pipeline stage
        sum01 <= pp[0] + pp[1];
        sum23 <= pp[2] + pp[3];
        
        // Second pipeline stage
        final_sum <= sum01 + sum23;
        mul_out <= final_sum;
    end
end

endmodule