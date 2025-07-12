module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Combinatorial zero extension
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Pipeline stage 1: Partial products and first addition
    reg [2*size-1:0] sum01, sum23;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 0;
            sum23 <= 0;
        end else begin
            sum01 <= (ext_b[0] ? ext_a : 0) + (ext_b[1] ? (ext_a << 1) : 0);
            sum23 <= (ext_b[2] ? (ext_a << 2) : 0) + (ext_b[3] ? (ext_a << 3) : 0);
        end
    end

    // Pipeline stage 2: Final addition and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum01 + sum23;
        end
    end

endmodule