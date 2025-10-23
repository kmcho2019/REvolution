module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // --- Combinational partial products ---
    wire [2*size-1:0] pp0 = mul_b[0] ? (ext_mul_a << 0) : {2*size{1'b0}};
    wire [2*size-1:0] pp1 = mul_b[1] ? (ext_mul_a << 1) : {2*size{1'b0}};
    wire [2*size-1:0] pp2 = mul_b[2] ? (ext_mul_a << 2) : {2*size{1'b0}};
    wire [2*size-1:0] pp3 = mul_b[3] ? (ext_mul_a << 3) : {2*size{1'b0}};

    // --- Stage 1 registers: latch partial products ---
    reg [2*size-1:0] stage1_pp0, stage1_pp1, stage1_pp2, stage1_pp3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_pp0 <= {2*size{1'b0}};
            stage1_pp1 <= {2*size{1'b0}};
            stage1_pp2 <= {2*size{1'b0}};
            stage1_pp3 <= {2*size{1'b0}};
        end else begin
            stage1_pp0 <= pp0;
            stage1_pp1 <= pp1;
            stage1_pp2 <= pp2;
            stage1_pp3 <= pp3;
        end
    end

    // --- Combinational sum of stage 1 partial products ---
    wire [2*size-1:0] sum01 = stage1_pp0 + stage1_pp1;
    wire [2*size-1:0] sum23 = stage1_pp2 + stage1_pp3;
    wire [2*size-1:0] sum_all = sum01 + sum23;

    // --- Stage 2 register: latch final sum ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= sum_all;
    end

endmodule