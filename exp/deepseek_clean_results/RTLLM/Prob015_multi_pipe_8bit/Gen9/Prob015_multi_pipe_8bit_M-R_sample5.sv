module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] stage1_a, stage1_b;
    reg [15:0] stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3;
    reg [15:0] stage3_sum0, stage3_sum1;
    reg [15:0] stage4_result;
    
    // Enable shift register (4 stages)
    reg [3:0] enable_pipe = 4'b0;
    
    // Partial products (combinational)
    wire [15:0] pp0 = {8'b0, stage1_a} & {16{stage1_b[0]}};
    wire [15:0] pp1 = ({7'b0, stage1_a, 1'b0} & {16{stage1_b[1]}});
    wire [15:0] pp2 = ({6'b0, stage1_a, 2'b0} & {16{stage1_b[2]}});
    wire [15:0] pp3 = ({5'b0, stage1_a, 3'b0} & {16{stage1_b[3]}});
    wire [15:0] pp4 = ({4'b0, stage1_a, 4'b0} & {16{stage1_b[4]}});
    wire [15:0] pp5 = ({3'b0, stage1_a, 5'b0} & {16{stage1_b[5]}});
    wire [15:0] pp6 = ({2'b0, stage1_a, 6'b0} & {16{stage1_b[6]}});
    wire [15:0] pp7 = ({1'b0, stage1_a, 7'b0} & {16{stage1_b[7]}});
    
    // Intermediate sums (combinational)
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    wire [15:0] sum0123 = sum01 + sum23;
    wire [15:0] sum4567 = sum45 + sum67;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage2_pp0 <= 16'b0;
            stage2_pp1 <= 16'b0;
            stage2_pp2 <= 16'b0;
            stage2_pp3 <= 16'b0;
            stage3_sum0 <= 16'b0;
            stage3_sum1 <= 16'b0;
            stage4_result <= 16'b0;
            enable_pipe <= 4'b0;
        end else begin
            // Stage 1: Input registration
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            
            // Stage 2: Partial product registration
            stage2_pp0 <= sum01;
            stage2_pp1 <= sum23;
            stage2_pp2 <= sum45;
            stage2_pp3 <= sum67;
            
            // Stage 3: Intermediate sum registration
            stage3_sum0 <= sum0123;
            stage3_sum1 <= sum4567;
            
            // Stage 4: Final result registration
            stage4_result <= stage3_sum0 + stage3_sum1;
            
            // Enable propagation
            enable_pipe <= {enable_pipe[2:0], mul_en_in};
        end
    end
    
    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = enable_pipe[3] ? stage4_result : 16'b0;

endmodule