module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Input extension as specified
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Stage 1: Partial Product Generation and First Addition
reg [2*size-1:0] sum0, sum1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= '0;
        sum1 <= '0;
    end else begin
        // Generate and sum partial products in pairs
        sum0 <= (ext_b[0] ? ext_a : '0) + (ext_b[1] ? (ext_a << 1) : '0);
        sum1 <= (ext_b[2] ? (ext_a << 2) : '0) + (ext_b[3] ? (ext_a << 3) : '0);
    end
end

// Stage 2: Final Sum and Output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= '0;
    end else begin
        mul_out <= sum0 + sum1;
    end
end

endmodule