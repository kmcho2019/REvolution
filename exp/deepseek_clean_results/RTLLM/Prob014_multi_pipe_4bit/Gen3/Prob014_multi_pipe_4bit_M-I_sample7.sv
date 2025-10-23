module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Clock gating control
    wire inputs_nonzero = |mul_a || |mul_b;
    wire gated_clk = clk & inputs_nonzero;

    // Extended inputs with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Partial products packed array
    wire [2*size-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = b_ext[i] ? (a_ext << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline registers (packed array)
    reg [2*size-1:0] stage_regs [0:1];
    wire [2*size-1:0] stage0_sum = pp[0] + pp[1] + pp[2];  // First stage adds 3 terms
    wire [2*size-1:0] stage1_sum = stage_regs[0] + pp[3];  // Second stage adds last term

    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            stage_regs[0] <= 0;
            stage_regs[1] <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage
            stage_regs[0] <= stage0_sum;
            
            // Second pipeline stage
            stage_regs[1] <= stage1_sum;
            mul_out <= stage_regs[1];
        end
    end

endmodule