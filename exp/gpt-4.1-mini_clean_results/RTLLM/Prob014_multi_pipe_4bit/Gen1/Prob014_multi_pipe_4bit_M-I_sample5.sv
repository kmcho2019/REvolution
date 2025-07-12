module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend multiplicand by size zeros at MSB (left side)
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Generate partial products: each is multiplicand shifted by i if mul_b[i] = 1, else zero
    wire [2*size-1:0] partial [0:size-1];

    // Hardcode shifts instead of using variable shift operator
    assign partial[0] = mul_b[0] ? a_ext : {2*size{1'b0}};
    assign partial[1] = mul_b[1] ? { { (2*size - (1 + size)){1'b0} }, mul_a, {1{1'b0}} } : {2*size{1'b0}}; // mul_a << 1
    assign partial[2] = mul_b[2] ? { { (2*size - (2 + size)){1'b0} }, mul_a, {2{1'b0}} } : {2*size{1'b0}}; // mul_a << 2
    assign partial[3] = mul_b[3] ? { { (2*size - (3 + size)){1'b0} }, mul_a, {3{1'b0}} } : {2*size{1'b0}}; // mul_a << 3

    // Pipeline registers
    reg [2*size-1:0] reg_stage1 [0:1];
    reg [2*size-1:0] reg_stage2;

    // First pipeline stage: sum partial products in pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1[0] <= {2*size{1'b0}};
            reg_stage1[1] <= {2*size{1'b0}};
        end else begin
            reg_stage1[0] <= partial[0] + partial[1];
            reg_stage1[1] <= partial[2] + partial[3];
        end
    end

    // Second pipeline stage: sum of first stage results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= {2*size{1'b0}};
        end else begin
            reg_stage2 <= reg_stage1[0] + reg_stage1[1];
        end
    end

    // Final product output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= reg_stage2;
        end
    end

endmodule