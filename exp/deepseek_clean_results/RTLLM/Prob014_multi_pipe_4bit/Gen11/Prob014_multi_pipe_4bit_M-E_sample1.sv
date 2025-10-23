module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers (carry-save format)
reg [2*size-1:0] sum [0:size];
reg [2*size-1:0] carry [0:size];

// Zero-extended multiplicand
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// Pipeline processing
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline stages
        for (i = 0; i <= size; i = i + 1) begin
            sum[i] <= 0;
            carry[i] <= 0;
        end
        mul_out <= 0;
    end else begin
        // Stage 0: Initialization
        sum[0] <= 0;
        carry[0] <= 0;
        
        // Stages 1-4: Bit-serial processing
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
                // Add shifted multiplicand (using carry-save)
                {carry[i+1], sum[i+1]} <= 
                    {1'b0, sum[i][2*size-2:0], 1'b0} +  // Shifted sum
                    {1'b0, carry[i][2*size-2:0], 1'b0} + // Shifted carry
                    a_ext;
            end else begin
                // Just shift previous result
                carry[i+1] <= {carry[i][2*size-2:0], 1'b0};
                sum[i+1] <= {sum[i][2*size-2:0], 1'b0};
            end
        end
        
        // Final stage: Convert carry-save to binary
        mul_out <= sum[size] + carry[size];
    end
end

endmodule