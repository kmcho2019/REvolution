module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Clock gating control
    wire inputs_non_zero = |mul_a || |mul_b;
    wire pipeline_enable = inputs_non_zero || !rst_n;

    // Extended inputs with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Partial products array
    wire [2*size-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = b_ext[i] ? (a_ext << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Shared pipeline registers
    reg [2*size-1:0] pipe_regs [0:2]; // 0:sum01, 1:pp2, 2:sum_all

    always @(posedge clk) begin
        if (!rst_n) begin
            // Synchronous reset
            pipe_regs[0] <= 0;
            pipe_regs[1] <= 0;
            pipe_regs[2] <= 0;
            mul_out <= 0;
        end else if (pipeline_enable) begin
            // Stage 1: Sum first two PPs and store third PP
            pipe_regs[0] <= pp[0] + pp[1];
            pipe_regs[1] <= pp[2];
            
            // Stage 2: Final accumulation
            pipe_regs[2] <= pipe_regs[0] + pipe_regs[1] + pp[3];
            
            // Registered output
            mul_out <= pipe_regs[2];
        end
        // When disabled, registers hold their values (clock gating effect)
    end

endmodule