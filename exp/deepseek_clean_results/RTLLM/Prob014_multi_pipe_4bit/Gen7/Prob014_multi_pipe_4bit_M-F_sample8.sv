module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input en,           // Enable signal for power optimization
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Stage 1: Partial product generation
reg [2*size-1:0] pp [0:size-1];
reg [2*size-1:0] sum_stage1;

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : pp_gen
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                pp[i] <= {2*size{1'b0}};
            end else if (en) begin
                pp[i] <= mul_b[i] ? (mul_a << i) : {2*size{1'b0}};
            end
        end
    end
endgenerate

// Stage 2: First level of addition (pipelined)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= {2*size{1'b0}};
    end else if (en) begin
        sum_stage1 <= pp[0] + pp[1] + pp[2] + pp[3];
    end
end

// Stage 3: Final output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else if (en) begin
        mul_out <= sum_stage1;
    end
end

endmodule