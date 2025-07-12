module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] a_ext = {mul_a, {size{1'b0}}};

    // Partial products for each bit of multiplier (no extension on multiplier)
    wire [2*size-1:0] partial [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIALS
            // Instead of variable shift, use concatenation for left shift by i bits:
            // Left shift a_ext by i bits = {a_ext[2*size-1 - i:0], i'b0}
            wire [2*size-1:0] shifted;
            assign shifted = (i == 0) ? a_ext :
                             (i == 1) ? {a_ext[2*size-2:0], 1'b0} :
                             (i == 2) ? {a_ext[2*size-3:0], 2'b00} :
                             (i == 3) ? {a_ext[2*size-4:0], 3'b000} :
                             {2*size{1'b0}}; // default (shouldn't happen for size=4)

            assign partial[i] = mul_b[i] ? shifted : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for two levels of accumulation
    reg [2*size-1:0] reg_stage1 [0:1];
    reg [2*size-1:0] reg_stage2;

    // First pipeline stage: sum partial products in pairs (0+1), (2+3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1[0] <= {2*size{1'b0}};
            reg_stage1[1] <= {2*size{1'b0}};
        end else begin
            reg_stage1[0] <= partial[0] + partial[1];
            reg_stage1[1] <= partial[2] + partial[3];
        end
    end

    // Second pipeline stage: sum results from first stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= {2*size{1'b0}};
        end else begin
            reg_stage2 <= reg_stage1[0] + reg_stage1[1];
        end
    end

    // Final output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= reg_stage2;
        end
    end

endmodule