module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand and its shifted versions
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_a_1 = ext_a << 1;
wire [2*size-1:0] ext_a_2 = ext_a << 2;
wire [2*size-1:0] ext_a_3 = ext_a << 3;

// Pipeline stage 1: Intermediate sums
reg [2*size-1:0] sum01, sum23;

always @(posedge clk) begin
    if (!rst_n) begin
        sum01 <= 0;
        sum23 <= 0;
    end else begin
        // First stage additions
        sum01 <= (ext_a   & {2*size{mul_b[0]}}) + 
                 (ext_a_1 & {2*size{mul_b[1]}});
        sum23 <= (ext_a_2 & {2*size{mul_b[2]}}) + 
                 (ext_a_3 & {2*size{mul_b[3]}});
    end
end

// Pipeline stage 2: Final sum
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum01 + sum23;
    end
end

endmodule