module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Pipeline registers
    reg [size-1:0] a_stage [size:0];  // Multiplicand pipeline
    reg [size-1:0] b_stage [size:0];  // Multiplier pipeline
    reg [2*size-1:0] acc_stage [size:0]; // Accumulator pipeline
    
    // Initialize pipeline
    integer k;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (k = 0; k <= size; k = k + 1) begin
                a_stage[k] <= {size{1'b0}};
                b_stage[k] <= {size{1'b0}};
                acc_stage[k] <= {2*size{1'b0}};
            end
            mul_out <= {2*size{1'b0}};
        end else begin
            // Stage 0: Input sampling
            a_stage[0] <= mul_a;
            b_stage[0] <= mul_b;
            acc_stage[0] <= {2*size{1'b0}};
            
            // Pipeline stages 1 through 4
            for (k = 1; k <= size; k = k + 1) begin
                a_stage[k] <= a_stage[k-1];
                b_stage[k] <= b_stage[k-1];
                
                if (b_stage[k-1][k-1]) begin
                    // Shift and add when multiplier bit is 1
                    acc_stage[k] <= acc_stage[k-1] + 
                                   {{(2*size-size-(k-1)){1'b0}}, 
                                    a_stage[k-1], 
                                    {(k-1){1'b0}}};
                end else begin
                    // Pass through when multiplier bit is 0
                    acc_stage[k] <= acc_stage[k-1];
                end
            end
            
            // Final output
            mul_out <= acc_stage[size];
        end
    end

endmodule