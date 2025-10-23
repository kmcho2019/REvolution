module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended input signals
reg [2*size-1:0] ext_mul_a;
reg [2*size-1:0] ext_mul_b;

// Intermediate registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Generate block for partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            assign ext_mul_a = { {size{1'b0}}, mul_a } << i;
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 0;
                end else begin
                    reg1 <= ext_mul_a;
                end
            end
        end else begin
            assign ext_mul_a = 0;
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 0;
                end else begin
                    reg1 <= 0;
                end
            end
        end
    end
endgenerate

// Add operation for partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 0;
    end else begin
        reg2 <= reg1;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule